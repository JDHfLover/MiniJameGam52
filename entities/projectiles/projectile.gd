extends Area2D
class_name Projectile

@export var speed: float
@export var life_time: float
var life_time_left := life_time
var damage: float

var target: Node2D
var direction:Vector2

func _on_area_entered(area):
	if(area.get_parent() == target):
		target.take_damage(damage)
		queue_free()

func _physics_process(delta: float) -> void:
	if(is_instance_valid(target)):direction = (target.global_position - global_position).normalized()
	global_position += direction*speed*delta
	life_time-=delta
	if(life_time <= 0):queue_free()
	
