extends Node2D

@onready var money_label: Label = get_tree().get_first_node_in_group("hud").get_node("MoneyGroup").get_node("Label")
@export var money: int = 0:
	set(value):
		money = value
		money_amount_changed.emit(money)
		update_money_label()


signal  money_amount_changed(new_amount)

func  _ready() -> void:
	update_money_label()

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
	
func update_money_label():
	if(is_instance_valid(money_label)):money_label.text = str(money)
