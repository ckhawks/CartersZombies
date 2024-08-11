extends Control


@onready var numOfPlayersSlider : HSlider = %NumberOfPlayersHSlider
@onready var playerCustomizersVBox : HBoxContainer = %PlayerCustomizersHBox

var playerCustomizerComponent = preload("res://scenes/MainMenu/MainMenuPlayerCustomizerComponent.tscn");

var playerControls = [
	preload("res://p1_controls.tres"),
	preload("res://p2_controls.tres"),
	preload("res://p1_controls.tres"), # TODO fix this
	preload("res://p1_controls.tres"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_number_of_players_h_slider_drag_ended(value_changed: bool) -> void:
	# update number of player boxes showing based on slider value
	if (len(playerCustomizersVBox.get_children()) != numOfPlayersSlider.value):
		var childs = playerCustomizersVBox.get_children()
		
		for child in childs:
			child.queue_free()
	
		for i in range(numOfPlayersSlider.value):
			var newPlayerCustomizerComponent = playerCustomizerComponent.instantiate();
			newPlayerCustomizerComponent.playerIdx = i;
			newPlayerCustomizerComponent.playerControls = playerControls[i]
			playerCustomizersVBox.add_child(newPlayerCustomizerComponent)


func _on_start_button_pressed() -> void:
	Overlord.changeToGameplayMainScene()
	Overlord.setMissionInformation({
		"map": "map"
	});
	
	var playerCustomizers = playerCustomizersVBox.get_children()
	var playersInfo = []
	for playerCustomizer in playerCustomizers:
		playersInfo.append(playerCustomizer.getPlayerInfoAsDict())
	Overlord.setPlayerInformation({
		"numPlayers": %NumberOfPlayersHSlider.value,
		"players": playersInfo
	})
	
