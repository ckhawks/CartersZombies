extends Control

@export var playerForIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("moneyChanged", on_change_money)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_change_money(playerIdx, credits, changeAmount) -> void:
	if playerIdx == playerForIndex:
		%CreditsLabel.text = "¢ " + str(credits)
		spawnPopupChangeIndicator(changeAmount)

func spawnPopupChangeIndicator(amount: int) -> void:
	var flyer : Label = $CreditsFlying.duplicate()
	
	add_child(flyer)
	flyer.process_mode = Node.PROCESS_MODE_INHERIT
	if(amount > 0):
		flyer.text = "+" + str(amount)
	else:
		flyer.text = str(amount)
		flyer.modulate = Color.hex(0xff6856FF)
	flyer.visible = true
