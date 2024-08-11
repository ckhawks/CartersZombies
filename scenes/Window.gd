extends StaticBody2D

var MAX_BOARDS = 4
var boards = 4

var windowTextures = {
	0: preload("res://sprites/windowA.png"),
	1: preload("res://sprites/windowA_1.png"),
	2: preload("res://sprites/windowA_2.png"),
	3: preload("res://sprites/windowA_3.png"),
	4: preload("res://sprites/windowA_4.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_repair_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		%Label.visible = true
		#print("can repair")
	
func _on_repair_area_2d_body_exited(body: Node2D) -> void:
	if $RepairArea2D.has_overlapping_bodies():
		var hasPlayer = false
		for bodyv in $RepairArea2D.get_overlapping_bodies():
			if bodyv.is_in_group("players"):
				hasPlayer = true
		if not hasPlayer:
			%Label.visible = false

func _on_damage_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if $DamageTimer.is_stopped():
			$DamageTimer.start()

func update_appearance() -> void:
	$Sprite2D.texture = windowTextures[boards]
	%Label.text = str(boards) + "/" + str(MAX_BOARDS)
	
	$CollisionShape2D.disabled = boards <= 0 # update collision property of window

func _on_damage_timer_timeout() -> void:
	if boards > 0:
		#print("damage time!!")
		var hasEnemy = false
		for body in $DamageArea2D.get_overlapping_bodies():
			if body.is_in_group("enemies"):
				hasEnemy = true
				boards = boards - 1
				update_appearance()
				#print("damaged")
				$DamageTimer.start()
				$BarricadeBreakAudioPlayer2D.pitch_scale = randf_range(0.95, 1.05)
				$BarricadeBreakAudioPlayer2D.play()

var canRepair = true
func repair(playerIdx: int) -> void:
	if canRepair == true:
		if(boards < MAX_BOARDS):
			for body in $DamageArea2D.get_overlapping_bodies():
				if body.is_in_group("enemies"):
					return
			boards = clamp(boards + 1, 0, 4)
			update_appearance()
			MoneyManager.addMoney(playerIdx, MoneyManager.moneyDefs["repairWindowBarricade"])
			$RepairTimer.start()
			$BarricadeRepairAudioPlayer2D.pitch_scale = randf_range(0.9, 1.1)
			$BarricadeRepairAudioPlayer2D.play()
			canRepair = false

func _on_repair_timer_timeout() -> void:
	canRepair = true
