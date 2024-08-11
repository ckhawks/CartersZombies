extends Area2D

@export var speed = 750
@export var damage = 15
@export var fromPlayerIndex = 0

var starting_pos : Vector2
var max_travel = 10000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_pos = global_position
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	position -= transform.y * speed * delta
	if position.distance_to(starting_pos) > max_travel:
		queue_free()

func _on_Bullet_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			#body.take_damage(body.global_position, damage)
			body.take_damage(damage, fromPlayerIndex)
	playImpactSound()
	queue_free()

func playImpactSound() -> void:
	var impactAudio = $ImpactAudio2D
	if(impactAudio != null):
		impactAudio.reparent(get_parent(), true)
		impactAudio.global_position = global_position
		impactAudio.pitch_scale = randf_range(0.9, 1.1)
		impactAudio.volume_db = randf_range(-30, -25)
		impactAudio.play()
		impactAudio.connect("finished", func(): impactAudio.queue_free())
