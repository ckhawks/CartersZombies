extends StaticBody2D

@onready var windowBase = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact(playerIdx: int) -> void:
	#print("Player " + str(playerIdx) + " interacted with this window.")
	windowBase.repair(playerIdx)
