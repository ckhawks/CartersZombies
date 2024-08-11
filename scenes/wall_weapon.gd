extends StaticBody2D

@export var weapon : WeaponResource = preload("res://resources/weapons/MP5.tres")

var viewingPlayerIndexes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setupForWeapon()
	pass # Replace with function body.

func setupForWeapon() -> void:
	$Sprite2D.texture = weapon.wallTexture;
	$Label.text = weapon.weaponName + "  $" + str(weapon.purchaseCost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact(playerIdx: int) -> void:
	if MoneyManager.canAfford(playerIdx, weapon.purchaseCost):
		MoneyManager.removeMoney(playerIdx, weapon.purchaseCost)
		print("congrats you got no " + weapon.weaponName + " get scammed")

func showInteractability(playerIdx) -> void:
	viewingPlayerIndexes.append(playerIdx)
	$Label.visible = true
	$Sprite2D.modulate.a = 1

func hideInteractability(playerIdx) -> void:
	var i = viewingPlayerIndexes.find(playerIdx)
	if i >= 0:
		viewingPlayerIndexes.remove_at(i)
		if(len(viewingPlayerIndexes) == 0):
			$Label.visible = false
			$Sprite2D.modulate.a = 0.5
