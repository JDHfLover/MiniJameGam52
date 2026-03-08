extends PathFollow2D
class_name Enemy


@export var speed: float
@export var damage: int
@export var max_health: float
@export var money_dropped: float
@onready var health := max_health 
var is_moving := false

@export var water_gradient: Gradient
@onready var water: Sprite2D = $Water
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var money_manager: Node2D

func _ready() -> void:
	money_manager = get_tree().get_first_node_in_group("money_manager")
	anim_player.play("spawn")

func _physics_process(delta: float) -> void:
	water.modulate = water_gradient.sample(health/max_health)
	if(is_moving): progress += speed * delta
	if(progress_ratio >= 1.0):
		get_tree().get_first_node_in_group("health_manager").take_damage(damage)

func _on_animation_finished(anim_name:String):
	if (anim_name == "spawn"):
		is_moving = true
		anim_player.play("move")
	if (anim_name == "die"):
		queue_free()

func take_damage(damage: float):
	health-=damage
	health = clamp(health,0,max_health)
	if(health <= 0):die()

func die():
	if anim_player.current_animation == "die": return
	is_moving = false
	money_manager.add_money(money_dropped)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	anim_player.play("die")
