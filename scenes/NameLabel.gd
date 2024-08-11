extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	get_parent().get_parent().rotation = -get_parent().get_parent().get_parent().rotation
