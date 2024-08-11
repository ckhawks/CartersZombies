extends Label

@export var speed = 35
@export var expSpeedFactor = 1.2

var verticalRandomChange : float = 0.0
var rotationRandomChange : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	verticalRandomChange = randf_range(-10, 10)
	rotationRandomChange = randf_range(-15, 15)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = get_position()
	pos = pos + Vector2(delta * speed * expSpeedFactor, verticalRandomChange * delta)
	rotation_degrees += rotationRandomChange * delta
	set_position(pos)
	modulate.a = modulate.a - 0.005
	if modulate.a <= 0:
		queue_free()
