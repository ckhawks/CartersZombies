extends Node

@export var WAVE_1_ZOMBIES = 2
@export var ZOMBIE_COUNT_MULTIPLIER = 1.1

var currentWaveZombieTotalCount = WAVE_1_ZOMBIES
var zombiesSpawnedForWave = 0
var waveSpawningDuration = 30 # seconds
var rng = RandomNumberGenerator.new()

var baseZombie = preload("res://scenes/zombie.tscn");

var enemiesKilled = 0
var currentWaveNumber = 1

var availableSpawnpoints = []

var gracePeriodTimer : Timer = null
var zombieSpawnTimer : Timer = null

func createTimers() -> void:
	gracePeriodTimer = Timer.new()
	availableSpawnpoints[0].get_parent().add_child(gracePeriodTimer)
	gracePeriodTimer.wait_time = 5
	gracePeriodTimer.one_shot = true
	gracePeriodTimer.connect("timeout", on_wave_end_grace_period_ended)
	
	zombieSpawnTimer = Timer.new()
	availableSpawnpoints[0].get_parent().add_child(zombieSpawnTimer)
	zombieSpawnTimer.wait_time = 3
	zombieSpawnTimer.one_shot = true
	zombieSpawnTimer.connect("timeout", on_zombie_spawn_timer_fired)
	

# every time the timer fires, try to spawn a zombie if we are under the required count for the wave
func on_zombie_spawn_timer_fired() -> void:
	if (zombiesSpawnedForWave < currentWaveZombieTotalCount):
		spawnZombie()
		
		zombieSpawnTimer.wait_time = randf_range(0, 7) # TODO reduce second number as zombie count increases
		zombieSpawnTimer.start()
	else:
		pass
		# do not start timer again
	
	

func on_wave_end_grace_period_ended() -> void:
	currentWaveNumber = currentWaveNumber + 1
	runWave(currentWaveNumber)

func _ready() -> void:
	SignalBus.enemyKilled.connect(on_enemy_killed)

func setupMission() -> void:
	activateInitialSpawnpoints()
	createTimers()
	# startMission()

func on_enemy_killed(playerIdx: int) -> void:
	enemiesKilled = enemiesKilled + 1
	
	# check if wave over, if so start next
	if(enemiesKilled >= currentWaveZombieTotalCount):
		print("All zombies were killed, starting pre-next wave grace period.")
		gracePeriodTimer.start()
		SignalBus.waveStarting.emit(currentWaveNumber + 1)

# spawn a new zombie into the world
func spawnZombie():
	var spawnpoint = pickSpawnpointFromAvailable()
	var newZombie = baseZombie.instantiate()
	spawnpoint.get_parent().add_child(newZombie)
	newZombie.global_position = spawnpoint.global_position
	zombiesSpawnedForWave = zombiesSpawnedForWave + 1
	
func pickSpawnpointFromAvailable() -> Node2D:
	var i = rng.randi_range(0, len(availableSpawnpoints) - 1)
	return availableSpawnpoints[i]

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

# TODO make it so all spawnpoints with roomId = 0 start active 
# TODO make it so that when a room is opened, the new spawnpoints are added to a list so we can randomly choose spawnpoints more efficiently

func activateInitialSpawnpoints() -> void:
	# get spawnpoints that are roomId 0 and mark them active
	var spawnpoints = get_tree().get_nodes_in_group("spawnpoints")
	for spawnpoint in spawnpoints:
		if spawnpoint.roomId == 0:
			availableSpawnpoints.append(spawnpoint)

func startMission() -> void:
	activateInitialSpawnpoints()
	currentWaveNumber = 1
	currentWaveZombieTotalCount = WAVE_1_ZOMBIES
	runWave(currentWaveNumber)
	zombieSpawnTimer.start()
	
func runWave(waveNumber: int) -> void:
	print("Wave " + str(waveNumber) + " starting...")
	currentWaveZombieTotalCount = ceil(currentWaveZombieTotalCount * ZOMBIE_COUNT_MULTIPLIER)
	SignalBus.waveStarted.emit(waveNumber)
	enemiesKilled = 0 # reset
	zombiesSpawnedForWave = 0
	zombieSpawnTimer.start()
	#for zombie in currentWaveZombieTotalCount:
		#spawnZombie()
		#wait(float(waveSpawningDuration) / float(currentWaveZombieTotalCount))
