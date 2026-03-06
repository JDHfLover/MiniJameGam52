extends Node2D


@export var waves: Array[Wave] = []
var current_wave := 0
var current_enemy := 0 

@onready var enemy_timer: Timer = $EnemyTimer
@onready var wave_timer: Timer = $WaveTimer
@onready var enemy_path: Path2D

func _ready() -> void:
	enemy_path = get_tree().get_first_node_in_group("enemy_path")

func _on_enemy_timer_timeout():
	spawn_next_enemy()

func _on_wave_timer_timeout():
	start_next_wave()

func end_wave():
	current_wave += 1
	if(current_wave < waves.size()):
		wave_timer.start(waves[current_wave].delay_before_wave)
	else:
		print("PEREMOGA U TRAVNI")

func start_next_wave():
	if current_wave < waves.size():
		current_enemy = 0
		enemy_timer.start(waves[current_wave].wave_items[current_enemy].delay_before_enemy)

func spawn_next_enemy():
	var enemy = waves[current_wave].wave_items[current_enemy].enemy.instantiate()
	enemy_path.add_child(enemy)
	current_enemy += 1
	if(current_enemy < waves[current_wave].wave_items.size()):
		enemy_timer.start(waves[current_wave].wave_items[current_enemy].delay_before_enemy)
	else:
		end_wave()

	
