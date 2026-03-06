extends Area2D
class_name Projectile

@export var speed: float
var damage: float

var target: Node2D
var direction:Vector2

func _on_area_entered(area):
	if(area.get_parent() == target):
		target.take_damage(damage)
		queue_free()

func _physics_process(delta: float) -> void:
	if(is_instance_valid(target)):
		direction = (target.global_position - global_position).normalized()
	else:
		queue_free()
	global_position += direction*speed*delta
	global_rotation = direction.angle()
	
