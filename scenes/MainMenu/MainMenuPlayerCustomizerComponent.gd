extends MarginContainer

@export var playerIdx = 0;
@export var playerControls : ControlsResource


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ColorPicker.color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1);
	%PlayerTitle.modulate = %ColorPicker.color
	%TestCharacterNode2D/Sprite2D.modulate = %ColorPicker.color
	%PlayerTitle.text = "Player " + str(playerIdx + 1)
	%NameLineEdit.placeholder_text = "Player " + str(playerIdx + 1)


var SPEED = 300;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Input.get_axis(playerControls.move_left, playerControls.move_right)
	if direction:
		%TestCharacterNode2D.velocity.x = direction * SPEED
	else:
		%TestCharacterNode2D.velocity.x = move_toward(%TestCharacterNode2D.velocity.x, 0, SPEED)
	%TestCharacterNode2D.move_and_slide()
	%TestCharacterNode2D.position.x = clamp(%TestCharacterNode2D.position.x, 32, 266)

func _on_color_picker_color_changed(color: Color) -> void:
	%PlayerTitle.modulate = %ColorPicker.color
	%TestCharacterNode2D/Sprite2D.modulate = %ColorPicker.color


func _on_randomize_color_button_pressed() -> void:
	%ColorPicker.color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1);
	%PlayerTitle.modulate = %ColorPicker.color
	%TestCharacterNode2D/Sprite2D.modulate = %ColorPicker.color

# 32-266

func getPlayerInfoAsDict() -> Dictionary:
	var playerName = %NameLineEdit.text
	if (playerName == ""):
		playerName = %NameLineEdit.placeholder_text
	
	return {
		"index": playerIdx,
		"controls": playerControls,
		"name": playerName,
		"color": %ColorPicker.color
	}
