extends Node

@export var playerMoney = [0, 0, 0, 0];
@export var startingMoney = 0;

@export var moneyDefs = {
	"bulletHit": 10,
	"enemyKill": 50,
	"repairWindowBarricade": 20
};



func _ready() -> void:
	resetMoneyToStarting()

#############################################
###      MONEY MONEY MONEY
#############################################
func resetMoneyToStarting() -> void:
	playerMoney[0] = startingMoney;
	playerMoney[1] = startingMoney;
	playerMoney[2] = startingMoney;
	playerMoney[3] = startingMoney;

func canAfford(playerIdx: int, amount: int) -> bool:
	return playerMoney[playerIdx] >= amount

func addMoney(playerIdx: int, amount: int) -> void:
	playerMoney[playerIdx] = playerMoney[playerIdx] + amount
	SignalBus.moneyChanged.emit(playerIdx, playerMoney[playerIdx], amount)
	
func removeMoney(playerIdx: int, amount: int) -> bool:
	if canAfford(playerIdx, amount):
		playerMoney[playerIdx] = playerMoney[playerIdx] - amount
		SignalBus.moneyChanged.emit(playerIdx, playerMoney[playerIdx], -amount)
		return true
	else:
		return false
