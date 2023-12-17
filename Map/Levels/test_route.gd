extends Path2D

var line2d : Line2D

func _ready():
	line2d = $Line2D

func _process(delta):
	_update_line2d()

func _update_line2d():
	line2d.clear_points()
	
	# Iterate through each point in Path2D
	for point in self.curve.get_baked_points():
		line2d.add_point(point + line2d.position) # Add the points to Line2D
