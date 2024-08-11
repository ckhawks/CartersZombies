extends Node

signal moneyChanged(playerIdx: int, credits: int, changeAmount: int)
signal changeHealth(playerIdx: int, health: float, maxHealth: float)
signal changeAmmo(playerIdx: int, currentAmmo: int, maxAmmo: int, reloading: bool)

signal waveStarting(waveNumber: int)
signal waveStarted(waveNumber: int)
signal enemyKilled(playerIdx: int)
signal roomOpened(roomNumber: int)


func _ready() -> void:
	roomOpened.connect(on_room_opened)
	
func on_room_opened(roomNumber: int) -> void:
	var spawnpoints = get_tree().get_nodes_in_group("spawnpoints")
	
	for spawnpoint in spawnpoints:
		if spawnpoint.roomId == roomNumber:
			spawnpoint.set_active(true)
