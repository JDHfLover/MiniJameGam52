extends Node2D
class_name Tower

@export var damage:float
@export var attack_range:float
@export var attack_speed:float

var attack_modes := ["first","last","random"]
var attack_mode := 0

@onready var attack_timer: Timer = $AttackTimer
@onready var attack_pivot: Node2D = $AttackPivot
@onready var attack_area: Area2D = $AttackArea
@export var projectile_scene: PackedScene

var targets: Array = []
var current_target = null


func _on_attack_area_area_entered(area):
	if (area.get_parent().is_in_group("enemy")):
		targets.append(area.get_parent())

func _on_attack_area_area_exited(area):
	targets.erase(area.get_parent())

func _physics_process(delta: float) -> void:
	update_target()
	attack_area.scale = Vector2.ONE*attack_range
	if(current_target and attack_timer.is_stopped()):
		attack()

func update_target():
	if(targets.is_empty()):
		current_target = null
		return
	targets.sort_custom(func(a,b): return a.progress > b.progress)
	var index: int
	if(attack_modes[attack_mode] == "first"):index = 0
	elif (attack_modes[attack_mode] == "last"):index = targets.size()-1
	elif(attack_modes[attack_mode] == "random"): index = randi() % len(targets)
	current_target = targets[index]

func attack():
	var projectile = projectile_scene.instantiate()
	projectile.global_position = attack_pivot.global_position
	projectile.target = current_target
	projectile.damage = damage
	get_tree().current_scene.add_child(projectile)
	attack_timer.start(attack_speed)
	
