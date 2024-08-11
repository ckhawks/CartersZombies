extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setupSplitscreenViewports()
	Overlord.setMainScene(self)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setupSplitscreenViewports() -> void:
	var level = load("res://scenes/startingLevel.tscn").instantiate()
	var player1Camera = Camera2D.new()
	var player2Camera = Camera2D.new()
	var player3Camera = Camera2D.new()
	var player4Camera = Camera2D.new()
	
	var VBox1 = VBoxContainer.new()
	VBox1.custom_minimum_size.x = 1920
	VBox1.custom_minimum_size.x = 1080
	VBox1.add_theme_constant_override("separation", 0)
	add_child(VBox1)
	var HBox1 = HBoxContainer.new()
	HBox1.add_theme_constant_override("separation", 0)
	VBox1.add_child(HBox1)
	var HBox2 = HBoxContainer.new()
	HBox2.add_theme_constant_override("separation", 0)
	
	var SubViewport1 = SubViewport.new()
	SubViewport1.audio_listener_enable_2d = true
	var SubViewport2 = SubViewport.new()
	SubViewport2.audio_listener_enable_2d = true
	var SubViewport3 = SubViewport.new()
	SubViewport3.audio_listener_enable_2d = true
	var SubViewport4 = SubViewport.new()
	SubViewport4.audio_listener_enable_2d = true
	
	var PlayerUI1 = load("res://scenes/player_ui.tscn").instantiate()
	var PlayerUI2 = load("res://scenes/player_ui.tscn").instantiate()
	var PlayerUI3 = load("res://scenes/player_ui.tscn").instantiate()
	var PlayerUI4 = load("res://scenes/player_ui.tscn").instantiate()
	
	## ONE PLAYER
	if Globals.numberOfPlayers >= 1:
		var SubViewportContainer1 = SubViewportContainer.new()
		HBox1.add_child(SubViewportContainer1)
		
		SubViewportContainer1.add_child(SubViewport1)
		SubViewport1.add_child(level)
		
		PlayerUI1.setPlayerIndex(0)
		SubViewportContainer1.add_child(PlayerUI1)
		SubViewport1.add_child(player1Camera)
		var RemoteTransform1 = RemoteTransform2D.new()
		#SubViewport1.add_child(RemoteTransform1)
		Globals.playerScenes[0].add_child(RemoteTransform1)
		RemoteTransform1.remote_path = player1Camera.get_path()
		
		#SubViewportContainer1.custom_minimum_size = Vector2(1920, 1080)
		SubViewport1.size = Vector2(1920, 1080)
	
	if Globals.numberOfPlayers >= 2:
		var SubViewportContainer2 = SubViewportContainer.new()
		HBox1.add_child(SubViewportContainer2)
		SubViewportContainer2.add_child(SubViewport2)
		
		PlayerUI2.setPlayerIndex(1)
		PlayerUI1.get_node("WavesUI").position.x = 1920/2
		PlayerUI2.get_node("WavesUI").position.x = 1920/2
		SubViewportContainer2.add_child(PlayerUI2)
		
		SubViewport2.add_child(player2Camera)
		var RemoteTransform2 = RemoteTransform2D.new()
		#SubViewport1.add_child(RemoteTransform1)
		Globals.playerScenes[1].add_child(RemoteTransform2)
		RemoteTransform2.remote_path = player2Camera.get_path()
		
		#SubViewportContainer1.custom_minimum_size = Vector2(1920, 1080)
		SubViewport1.size = Vector2(1920/2, 1080)
		SubViewport2.size = Vector2(1920/2, 1080)
		SubViewport2.world_2d = SubViewport1.world_2d
		player1Camera.zoom = Vector2(0.9, 0.9)
		player2Camera.zoom = Vector2(0.9, 0.9)

	
	if Globals.numberOfPlayers == 3:
		var SubViewportContainer3 = SubViewportContainer.new()
		var centerContainer = CenterContainer.new()
		VBox1.add_child(centerContainer)
		centerContainer.add_child(SubViewportContainer3)
		SubViewportContainer3.add_child(SubViewport3)
		
		PlayerUI3.setPlayerIndex(2)
		PlayerUI3.get_node("WavesUI").position.x = 1920/2
		SubViewportContainer3.add_child(PlayerUI3)
		
		SubViewport3.add_child(player3Camera)
		var RemoteTransform3 = RemoteTransform2D.new()
		#SubViewport1.add_child(RemoteTransform1)
		Globals.playerScenes[2].add_child(RemoteTransform3)
		RemoteTransform3.remote_path = player3Camera.get_path()
		
		#SubViewportContainer1.custom_minimum_size = Vector2(1920, 1080)
		SubViewport1.size = Vector2(1920/2, 1080/2)
		SubViewport2.size = Vector2(1920/2, 1080/2)
		SubViewport3.size = Vector2(1920/2, 1080/2)
		SubViewport3.world_2d = SubViewport1.world_2d
		player1Camera.zoom = Vector2(0.8, 0.8)
		player2Camera.zoom = Vector2(0.8, 0.8)
		player3Camera.zoom = Vector2(0.8, 0.8)
	
	if Globals.numberOfPlayers == 4:
		var SubViewportContainer3 = SubViewportContainer.new()
		VBox1.add_child(HBox2)
		HBox2.add_child(SubViewportContainer3)
		SubViewportContainer3.add_child(SubViewport3)
		PlayerUI3.setPlayerIndex(2)
		PlayerUI3.get_node("WavesUI").position.x = 1920/2
		SubViewportContainer3.add_child(PlayerUI3)
		SubViewport3.add_child(player3Camera)
		var RemoteTransform3 = RemoteTransform2D.new()
		#SubViewport1.add_child(RemoteTransform1)
		Globals.playerScenes[2].add_child(RemoteTransform3)
		RemoteTransform3.remote_path = player3Camera.get_path()
		
		
		var SubViewportContainer4 = SubViewportContainer.new()
		HBox2.add_child(SubViewportContainer4)
		SubViewportContainer4.add_child(SubViewport4)
		
		PlayerUI4.setPlayerIndex(3)
		PlayerUI4.get_node("WavesUI").position.x = 1920/2
		SubViewportContainer4.add_child(PlayerUI4)
		
		SubViewport4.add_child(player4Camera)
		var RemoteTransform4 = RemoteTransform2D.new()
		#SubViewport1.add_child(RemoteTransform1)
		Globals.playerScenes[3].add_child(RemoteTransform4)
		RemoteTransform4.remote_path = player4Camera.get_path()
		
		#SubViewportContainer1.custom_minimum_size = Vector2(1920, 1080)
		SubViewport1.size = Vector2(1920/2, 1080/2)
		SubViewport2.size = Vector2(1920/2, 1080/2)
		SubViewport3.size = Vector2(1920/2, 1080/2)
		SubViewport4.size = Vector2(1920/2, 1080/2)
		SubViewport3.world_2d = SubViewport1.world_2d
		SubViewport4.world_2d = SubViewport1.world_2d
		player1Camera.zoom = Vector2(0.8, 0.8)
		player2Camera.zoom = Vector2(0.8, 0.8)
		player3Camera.zoom = Vector2(0.8, 0.8)
		player4Camera.zoom = Vector2(0.8, 0.8)
	
	# use Globals.numberOfPlayers and Globals.playerInformation
	
	# set Globals.levelScene
	pass
