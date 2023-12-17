extends Node2D

@onready var path = preload("res://Map/Levels/test_route.tscn")

func _on_timer_timeout():
	var new_unit = path.instantiate()
	add_child(new_unit)
