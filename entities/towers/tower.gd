extends Node2D
class_name Tower

var damage: float
var attack_range: float
var attack_speed: float
var upgrade_cost: int
@export var build_cost: int
var sell_cost: int = build_cost/2

var attack_modes := ["first","last","random"]
var attack_mode := 0
var current_level := 1

@export var levels: Array[TowerLevel] = []
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_pivot: Node2D = $AttackPivot
@onready var attack_area: Area2D = $AttackArea
@onready var level_indicator: Sprite2D = $LevelIndicator
@onready var animation_player: AnimationPlayer
@export var projectile_scene: PackedScene

var targets: Array = []
var current_target = null


func _on_attack_area_area_entered(area):
	if (area.get_parent().is_in_group("enemy")):
		targets.append(area.get_parent())

func _on_attack_area_area_exited(area):
	targets.erase(area.get_parent())

func _ready() -> void:
	attack_area.get_node("CollisionShape2D").shape = attack_area.get_node("CollisionShape2D").shape.duplicate()
	animation_player = get_node_or_null("AnimationPlayer")
	apply_level_stats()

func _physics_process(delta: float) -> void:
	if(attack_timer.is_stopped()):
		update_target()
		if(is_instance_valid(current_target)):
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

func spawn_projectile():
	if(!(is_instance_valid(current_target))):return
	var projectile = projectile_scene.instantiate()
	projectile.global_position = attack_pivot.global_position
	projectile.target = current_target
	projectile.damage = damage
	get_tree().current_scene.add_child(projectile)
	attack_timer.start(attack_speed)

func attack():
	if(animation_player):
		animation_player.play("attack")
	else:
		spawn_projectile()

func apply_level_stats():
	damage = levels[current_level-1].damage
	attack_speed = levels[current_level-1].attack_speed
	attack_range = levels[current_level-1].attack_range
	upgrade_cost = levels[current_level-1].upgrade_cost
	sell_cost += levels[current_level-1].upgrade_cost/2
	attack_area.get_node("CollisionShape2D").shape.radius = attack_range
	if(current_level == 1):
		level_indicator.hide()
	else:
		level_indicator.show()
		level_indicator.frame = current_level - 2
	if(animation_player):animation_player.speed_scale = 1/attack_speed

func upgrade():
	if(current_level >= levels.size()):
		return
	current_level += 1
	apply_level_stats()
	
