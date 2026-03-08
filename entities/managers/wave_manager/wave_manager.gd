extends Node2D


@export var waves: Array[Wave] = []
var current_wave := 0
var current_enemy := 0 

var enemy_timer: Timer
var wave_timer: Timer
var enemy_path: Path2D
var start_wave_button: Button
var time_left_label: Label

func _ready() -> void:
	enemy_timer = $EnemyTimer
	wave_timer = $WaveTimer
	enemy_path = get_tree().get_first_node_in_group("enemy_path")
	start_wave_button = get_tree().get_first_node_in_group("hud").get_node("WaveGroup").get_node("Button")
	time_left_label = start_wave_button.get_node("Label")
	start_wave_button.pressed.connect(_on_start_wave_pressed)
	start_wave_button.disabled = false

func _physics_process(delta: float) -> void:
	if(wave_timer.time_left > 0):
		time_left_label.show()
		time_left_label.text = str(int(ceil(wave_timer.time_left)))
	else:
		time_left_label.hide()

func _on_enemy_timer_timeout():
	spawn_next_enemy()

func _on_wave_timer_timeout():
	start_next_wave()

func end_wave():
	current_wave += 1
	if(current_wave < waves.size()):
		wave_timer.start(waves[current_wave].delay_before_wave)
		start_wave_button.disabled = false
	else:
		start_wave_button.hide()
		print("PEREMOGA U TRAVNI")

func start_next_wave():
	start_wave_button.disabled = true
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

func _on_start_wave_pressed():
	wave_timer.stop()
	start_next_wave()
