extends Node2D

var map_node

var current_wave: int = 0
var enemies_in_wave: int = 0

var build_mode: bool = false
var build_valid: bool = false
var build_tile
var build_location
var build_type

func _ready():
	map_node = get_node('TestLevel')
	
	for i in get_tree().get_nodes_in_group('build_buttons'):
#		i.('pressed', self, 'initiate_build_mode', [i.get_name()])
		i.pressed.connect(initiate_build_mode.bind(i.name))
		pass
		
	
	start_next_wave()

func _process(delta):
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type.to_snake_case()
	build_mode = true
	get_node('UI').set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var map = map_node.get_node('TileMap')
	var current_tile = map.local_to_map(map.to_local(mouse_position))
	var tile_position = map.to_global(map.map_to_local(current_tile))
#	print(map.get_layer_name(2))
	if map.get_cell_source_id(2, current_tile) == -1:
		get_node('UI').update_tower_preview(tile_position, 'ffffffaa')
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node('UI').update_tower_preview(tile_position, '000000')
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()


func verify_and_build():
	if build_valid:
		# TODO:
		# Test to verify player has enough cash
		var new_tower = load("res://Towers/" + build_type + '.tscn').instantiate()
		new_tower.position = build_location
		map_node.get_node('Turrets').add_child(new_tower, true)
		map_node.get_node('TileMap').set_cell(2, build_tile, 1, Vector2i(1, 0))
		# deduct cash
		# update cash label


###
# Wave functions
###

func start_next_wave():
	var wave_data = retrieve_wave_data()
#	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)
	

func retrieve_wave_data():
	var wave_data = [['white_ship', 0.7], ['white_ship', 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data


func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load('res://Mobs/' + i[0] + '.tscn').instantiate()
		map_node.get_node('MapRoute').add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout

