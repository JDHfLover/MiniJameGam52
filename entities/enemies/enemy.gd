extends PathFollow2D
class_name Enemy


@export var speed: float
@export var damage: float
@export var max_health:float 
@onready var health := max_health 

@onready var path: Path2D


func _physics_process(delta: float) -> void:
	progress += speed * delta

func take_damage(damage: float):
	health-=damage
	if(health <= 0):die()
	elif (health > max_health): health = max_health

func die():
	queue_free()
