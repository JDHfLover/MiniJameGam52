extends Node2D

@export var money: int = 0:
	set(value):
		money = value
		money_amount_changed.emit(money)

signal  money_amount_changed(new_amount)

func can_afford(amount: int) -> bool:
	return (amount <= money)

func spend_money(amount: int) -> bool:
	if(can_afford(amount)):
		money -= amount
		return true
	else:
		return false
	
func add_money(amount: int):
	money += amount
	
