extends Node2D

@export var drawing_color : Color = Color.WHITE
@export var drawing_line_width : float = 4.0
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
		draw_line(last_point, point, drawing_color, drawing_line_width)
		last_point = point
