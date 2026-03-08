extends Tower

var visual_attack_area: Sprite2D

func  _ready() -> void:
	visual_attack_area = $VisualAttackArea
	visual_attack_area.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
	super()

func attack():
	if(animation_player):
		animation_player.play("attack")
	for target in targets.duplicate():
		if(is_instance_valid(target) and target.has_method("take_damage")):
			target.take_damage(damage)
			
	attack_timer.start(attack_speed)

func apply_level_stats():
	super()
	visual_attack_area.scale = Vector2.ONE * attack_range/10
