extends Node2D

var map_node

var current_wave = 0
var enemies_in_wave = 0

func _ready():
	map_node = get_node('TestLevel')
	start_next_wave()

func start_next_wave():
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)
	

func retrieve_wave_data():
	var wave_data = [['white_ship', 0.7], ['white_ship', 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data


func spawn_enemies(wave_data):
	for i in wave_data:
		print('hello')
		var new_enemy = load('res://Mobs/' + i[0] + '.tscn').instantiate()
		map_node.get_node('MapRoute').add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout

