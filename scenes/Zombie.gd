extends CharacterBody2D

@export var MAX_HEALTH = 100
var health = MAX_HEALTH
@export var DAMAGE = 10
const MOVE_SPEED = 100.0

var movement_target_position: Vector2 = Vector2(60.0,180.0)
var targetPlayer = null

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	# Force update the navigation map
	call_deferred("_update_navigation_map")
	
	targetPlayer = locateTargetPlayer()
	
	# Configure the NavigationAgent2D
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	# Optionally, you can adjust the path max distance
	# navigation_agent.path_max_distance = 100.0
	
	# Connect to the velocity_computed signal
	navigation_agent.velocity_computed.connect(self._on_velocity_computed)
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
func _update_navigation_map() -> void:
	NavigationServer2D.map_force_update(get_world_2d().get_navigation_map())

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target()

func set_movement_target():
	navigation_agent.target_position = targetPlayer.global_position

#func _physics_process(delta: float) -> void:
	#if navigation_agent.is_navigation_finished():
		#return
#
	#var current_agent_position: Vector2 = global_position
	#var next_path_position: Vector2 = navigation_agent.get_next_path_position()
#
	#velocity = current_agent_position.direction_to(next_path_position) * MOVE_SPEED
	#rotation = velocity.angle()
#
	#move_and_slide()
	#set_movement_target()

func _physics_process(delta: float) -> void:
	#if navigation_agent.is_navigation_finished():
		#return
	#
	#var next_path_position = navigation_agent.get_next_path_position()
	#if global_position.distance_to(next_path_position) != 0.5:
		#var currentLocation = global_position
		#var newVelocity = (next_path_position - currentLocation).normalized() * MOVE_SPEED
		#velocity = newVelocity
		#rotation = velocity.angle()
	#set_movement_target()

	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_position = navigation_agent.get_next_path_position()
	var new_velocity = (next_path_position - global_position).normalized() * MOVE_SPEED
	
	if global_position.distance_to(next_path_position) > 5.0 or true: # for some reason this distance check was making him give up on the Nav links
		navigation_agent.set_velocity(new_velocity)
	else:
		navigation_agent.set_velocity(Vector2.ZERO)
	
	# Update rotation
	rotation = new_velocity.angle()
	#set_movement_target()

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func take_damage(damage: float, playerIdx: int) -> void:
	health -= damage
	MoneyManager.addMoney(playerIdx, MoneyManager.moneyDefs['bulletHit'])
	#print("taking damage " + str(damage) + ", health " + str(health))
	if health <= 0:
		MoneyManager.addMoney(playerIdx, MoneyManager.moneyDefs['enemyKill'])
		die(playerIdx) # todo fix this

func _on_hurt_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE)
			$HurtTimer.start()

func _on_hurt_timer_timeout() -> void:
	if $HurtArea2D.has_overlapping_bodies():
		for body in $HurtArea2D.get_overlapping_bodies():
			if body.is_in_group("players"):
				if body.has_method("take_damage"):
					body.take_damage(DAMAGE)
		$HurtTimer.start()

func locateTargetPlayer() -> Node2D:
	# search for closest player
	var players = get_tree().get_nodes_in_group("players")
	var closestPlayer = null
	var closestDistance = 10000
	for player in players:
		var disty = global_position.distance_to(player.global_position)
		if disty < closestDistance:
			closestPlayer = player
			closestDistance = disty
	return closestPlayer

func _on_locate_timer_timeout() -> void:
	targetPlayer = locateTargetPlayer()
	set_movement_target()
	#NavigationServer2D.map_force_update(get_world_2d().get_navigation_map())

func die(playerIdx) -> void:
	SignalBus.enemyKilled.emit(playerIdx)
	queue_free()

# TODO make locatetimer update time scale with player distance
# aka. farther player = update slower, closer player = update faster
