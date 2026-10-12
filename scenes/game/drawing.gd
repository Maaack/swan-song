extends Node2D

@export var points : Array[Vector2] :
	set(value):
		points = value
		queue_redraw()

func _draw():
	var last_point := Vector2.ZERO
	for point in points:
		if last_point == Vector2.ZERO:
			last_point = point
			continue
		draw_line(last_point, point, Color.BLACK, 4)
		last_point = point
