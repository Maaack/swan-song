extends Node2D

@export var data: Array = [] :
	set(value):
		data = value
		queue_redraw()
		drawing.queue_redraw()
@export_range(-PI, PI, 0.00001) var time: float = 0:
	set(value):
		time = value
		queue_redraw()
@export_range(0.1, 10) var time_mod: float = 1
@export_range(0, 1000, 1.0) var terms: int = 1 :
	set(value):
		terms = value
		queue_redraw()
		if is_inside_tree():
			drawing.points.clear()
@onready var drawing = %Drawing

func _draw():
	var x := 0.0
	var y := 0.0
	var max = min(data.size(), terms)
	for i in range(0, max):
		var prevx = x;
		var prevy = y;
		var freq = data[i].freq;
		var radius = data[i].amp;
		var phase = data[i].phase;
		x += radius * cos(freq * time + phase + rotation);
		y += radius * sin(freq * time + phase + rotation);

		# draw vector and circles
		draw_circle(Vector2(prevx, prevy), radius, Color(Color.BLUE_VIOLET, 0.5), false, 2)
		draw_line(Vector2(prevx, prevy), Vector2(x, y), Color(Color.WHITE, 0.5), 1)

	drawing.points.append(Vector2(x, y))
	drawing.queue_redraw()

func _process(delta):
	time += delta * time_mod
