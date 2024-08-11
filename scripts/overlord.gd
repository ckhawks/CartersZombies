extends Node

var mainScene : Node2D = null

func changeToGameplayMainScene() -> void:
	# load main game ui stuff
	get_tree().change_scene_to_packed(load("res://scenes/main.tscn"));

func setMainScene(node: Node2D) -> void:
	mainScene = node
	WaveManager.setupMission()
	setupPlayersInLevel()
	WaveManager.startMission()
	

func setMissionInformation(information: Dictionary) -> void:
	pass
	# handle map switching

func setPlayerInformation(information: Dictionary) -> void:
	Globals.numberOfPlayers = information['numPlayers']
	Globals.players = information['players']
	

func registerPlayerScene(playerIdx: int, node: Node2D) -> void:
	Globals.playerScenes[playerIdx] = node;

func setupPlayersInLevel() -> void:
	for player in Globals.players:
		var playerScene = Globals.playerScenes[player['index']]
		
		#if player['index'] > Globals.numberOfPlayers - 1:
			#playerScene.queue_free();
		#else:
		playerScene.playerColor = player['color'];
		playerScene.playerName = player['name'];
		playerScene.playerIdx = player['index'];
		playerScene.updatePlayerBasedOnVariables();
	
	for playerScene in Globals.playerScenes:
		print("len(Globals.players)", len(Globals.players))
		if(playerScene.playerIdx >= len(Globals.players)):
			playerScene.queue_free()
