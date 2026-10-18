extends Node2D

signal drawing_completed

@export var data: Array = [] :
	set(value):
		data = value
		time = -PI
		queue_redraw()
		if is_inside_tree():
			drawing.queue_redraw()
			is_drawing = true
@export_range(-PI, PI, 0.00001) var time: float = 0:
	set(value):
		time = value
		queue_redraw()
@export_range(0.1, 10) var time_mod: float = 1.0
@export_range(0, 1000, 1.0) var terms: int = 1 :
	set(value):
		terms = value
		time = -PI
		queue_redraw()
		if is_inside_tree():
			drawing.points.clear()
			is_drawing = true
@onready var drawing = %Drawing
@export var enabled : bool = false :
	set(value):
		enabled = value
		time = -PI
@export var radius_mode : int = 0 :
	set(value):
		radius_mode = value
		match(radius_mode):
			0:
				data.sort_custom(func(a, b) : return a.re > b.re )
			1:
				data.sort_custom(func(a, b) : return a.im > b.im )
			2:
				data.sort_custom(func(a, b) : return a.freq > b.freq )
			3:
				data.sort_custom(func(a, b) : return a.amp > b.amp )
			3:
				data.sort_custom(func(a, b) : return a.phase > b.phase )

var is_drawing : bool = true

func _draw():
	var x := 0.0
	var y := 0.0
	var data_max = min(data.size(), terms)
	for i in range(0, data_max):
		var prevx = x
		var prevy = y
		var freq = data[i].freq
		var radius:float = 0
		match(radius_mode):
			0:
				radius = data[i].re
			1:
				radius = data[i].im
			2:
				radius = data[i].freq * 0.1
			3:
				radius = data[i].amp
			4:
				radius = data[i].phase
		var phase = data[i].phase
		x += radius * cos(freq * time + phase + rotation)
		y += radius * sin(freq * time + phase + rotation)

		# draw vector and circles
		draw_circle(Vector2(prevx, prevy), radius, Color(Color.BLUE_VIOLET, 0.5), false, 2)
		draw_line(Vector2(prevx, prevy), Vector2(x, y), Color(Color.WHITE, 0.5), 1)
	if not enabled:
		return
	if time > 2 * PI:
		return
	drawing.points.append(Vector2(x, y))
	drawing.queue_redraw()

func _process(delta):
	time += delta * time_mod
	if not enabled:
		return
	if is_drawing and time > PI:
		drawing_completed.emit()
		is_drawing = false
	if delta > 0.1:
		drawing.points.clear()
