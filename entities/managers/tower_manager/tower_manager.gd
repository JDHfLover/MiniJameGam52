extends Node2D

var money_manager: Node2D
var hud: CanvasLayer
var tower_menu: Control
@export var tower_scenes: Array[PackedScene] = []
var active_tower_slot: Node2D
var upgrade_menu: Control
var build_menu: Control
var upgrade_button: Button
var sell_button: Button
var build_buttons: Array[Button] = []

func _ready() -> void:
	money_manager = get_tree().get_first_node_in_group("money_manager")
	hud = get_tree().get_first_node_in_group("hud")
	tower_menu = hud.get_node("TowerMenu")
	print(tower_menu)
	upgrade_menu = tower_menu.get_node("UpgradeMenu")
	build_menu = tower_menu.get_node("BuildMenu")
	upgrade_button = upgrade_menu.get_node("UpgradeButton")
	sell_button = upgrade_menu.get_node("SellButton")
	build_buttons.append(build_menu.get_node("BuildCoolerButton"))
	build_buttons.append(build_menu.get_node("BuildFridgeButton"))
	build_buttons.append(build_menu.get_node("BuildFountainButton"))
	build_buttons.append(build_menu.get_node("BuildCatapultButton"))
	upgrade_button.pressed.connect(_on_upgrade_button_click)
	sell_button.pressed.connect(_on_sell_button_click)
	for i in range(build_buttons.size()):
		build_buttons[i].pressed.connect(_on_build_button_click.bind(i))
		var tower = tower_scenes[i].instantiate()
		build_buttons[i].get_node("Label").text = str(tower.build_cost)
		tower.queue_free()
	for slot in get_tree().get_nodes_in_group("tower_slot"):
		slot.clicked.connect(_on_tower_slot_clicked)
	tower_menu.hide()

func open_upgrade_menu():
	var tower = active_tower_slot.get_child(-1)
	if(tower.current_level == tower.levels.size()):
		upgrade_button.disabled = true
		upgrade_button.get_node("Label").text = ""
	else:
		upgrade_button.disabled = false
		upgrade_button.get_node("Label").text = str(active_tower_slot.get_child(-1).upgrade_cost)
	sell_button.get_node("Label").text = str(active_tower_slot.get_child(-1).sell_cost)
	upgrade_menu.show()
	build_menu.hide()

func open_build_menu():
	upgrade_menu.hide()
	build_menu.show()

func _on_tower_slot_clicked(slot_node:Node2D):
	if (is_instance_valid(active_tower_slot) and active_tower_slot.get_child_count() > 0):
		var old_tower = active_tower_slot.get_child(-1)
		if(old_tower is Tower):
			old_tower.attack_range_shown = false
	active_tower_slot = slot_node
	var screen_pos = slot_node.get_global_transform_with_canvas().get_origin()
	var target_menu_pos = screen_pos - Vector2(tower_menu.size.x / 2, 0)
	if(tower_menu.visible and tower_menu.position == target_menu_pos):
		tower_menu.hide()
		return
	tower_menu.global_position = target_menu_pos
	if(slot_node.get_child(-1) is Tower):
		open_upgrade_menu()
		active_tower_slot.get_child(-1).attack_range_shown = true
	else:
		open_build_menu()
	tower_menu.show()
		
func _on_build_button_click(tower_index: int):
	var tower := tower_scenes[tower_index].instantiate()
	var cost = tower.build_cost
	if(money_manager.spend_money(cost)):
		active_tower_slot.add_child(tower)
		tower_menu.hide()
	else:
		tower.queue_free()

func _on_upgrade_button_click():
	var tower : Node2D = active_tower_slot.get_child(-1)
	var cost = tower.upgrade_cost
	if(tower.current_level >= tower.levels.size()):
		return
	if(money_manager.spend_money(cost)):
		tower.upgrade()
	open_upgrade_menu()

func _on_sell_button_click():
	var tower : Node2D = active_tower_slot.get_child(-1)
	var cost = tower.sell_cost
	money_manager.add_money(cost)
	tower.queue_free()
	tower_menu.hide()
