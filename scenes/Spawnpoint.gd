extends Node2D

@export var active = false
@export var roomId = 0

var spawning = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_active(value: bool) -> void:
	active = value

func get_active() -> bool:
	return active

func _on_entropy_timer_timeout() -> void:
	spawning = !spawning
	$ColorRect.visible = spawning
	$EntropyTimer.wait_time = randi_range(5, 12)
