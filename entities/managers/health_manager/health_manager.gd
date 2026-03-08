extends Node2D

@export var max_health: int
var health:int
@onready var health_label : Label = get_tree().get_first_node_in_group("hud").get_node("HealthGroup").get_node("Label")


func _ready() -> void:
	health = max_health
	print(health_label.global_position)
	update_health_label()
func take_damage(damage:int):
	health -= damage
	health = clamp(health,0.0,max_health)
	update_health_label()
	if(health == 0):
		game_over()

func update_health_label():
	if(is_instance_valid(health_label)):health_label.text = str(health)
		
func game_over():
	print("Game over")
	
