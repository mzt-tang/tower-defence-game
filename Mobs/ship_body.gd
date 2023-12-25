extends CharacterBody2D

# change to get_parent speed, health, etc.
@export var speed = 150

func _physics_process(delta):
	get_parent().set_progress(get_parent().get_progress() + (speed * delta))
	if get_parent().get_progress_ratio() == 1:
		queue_free()
