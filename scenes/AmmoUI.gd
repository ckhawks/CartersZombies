extends Control

@export var playerForIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("changeAmmo", on_change_ammo)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_change_ammo(playerIdx, currentAmmo, maxAmmo, reloading: bool) -> void:
	if playerIdx == playerForIndex:
		if reloading:
			%AmmoLabel.text = "Reloading..."
		else:
			%AmmoLabel.text = str(currentAmmo) + " / " + str(maxAmmo)
