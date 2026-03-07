extends PathFollow2D
class_name Enemy


@export var speed: float
@export var damage: float
@export var max_health:float 
@onready var health := max_health 
var is_moving := false

@export var water_gradient: Gradient
@onready var water: Sprite2D = $Water
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("spawn")

func _physics_process(delta: float) -> void:
	water.modulate = water_gradient.sample(health/max_health)
	if(is_moving): progress += speed * delta

func _on_animation_finished(anim_name:String):
	if (anim_name == "spawn"):
		is_moving = true
		anim_player.play("move")
	if (anim_name == "die"):
		queue_free()

func take_damage(damage: float):
	health-=damage
	if(health <= 0):die()
	elif (health > max_health): health = max_health

func die():
	is_moving = false
	anim_player.play("die")
