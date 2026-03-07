extends Resource
class_name Wave

@export var wave_items: Array[WaveItem] = []
@export var delay_before_wave:float
var current_item := 0
