extends Projectile

var water_wave: Area2D
var animation_player: AnimationPlayer
var sprite: Sprite2D
var start_pos: Vector2
var start_distance_to_target:float
var progress: float
@export var max_height:float

func _ready() -> void:
	animation_player = get_node("AnimationPlayer")
	water_wave = get_node("WaterWave")
	sprite = get_node("Sprite2D")
	water_wave.hide()
	start_pos = global_position
	start_distance_to_target = start_pos.distance_to(target.global_position)

func _physics_process(delta: float) -> void:
	if (not(is_instance_valid(target))):
		explode()
		return
	else: direction = (target.global_position - global_position).normalized()
	global_position += direction*speed*delta
	progress = clamp(1 - global_position.distance_to(target.global_position)/start_distance_to_target,0,1)
	sprite.position.y = 4*max_height*progress*(1-progress)

func _on_area_entered(area):
	if(area.get_parent() == target):
		explode()

func explode():
	set_physics_process(false)
	water_wave.show()
	sprite.hide()
	animation_player.play("explode")
	var areas := water_wave.get_overlapping_areas()
	for area in areas:
		if(is_instance_valid(area) and area.get_parent().has_method("take_damage")):
			area.get_parent().take_damage(damage)
