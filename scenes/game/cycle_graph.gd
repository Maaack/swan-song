extends Node2D

@export var cycle_series : Array :
	set(value):
		cycle_series = value
		cycle_series_size = cycle_series.size()
		max_y = 0
		for i in range(0, radius):
			var x = 2 * PI * i / float(radius)
			var y = cycle_func(x)
			max_y = max(y, max_y)
			y_values.append(y)
		queue_redraw()

@export var radius : float = 120
@export var show_parts : bool = true
@export var show_combined : bool = true

var cycle_series_size : int = 0
var y_values : Array[float]
var max_y : float = 0

@onready var total_check_box = %TotalCheckBox
@onready var parts_check_box = %PartsCheckBox
@onready var ticks_check_box = %TicksCheckBox

func cycle_func(x:float) -> float:
	return FourierTransform.total_value(x, cycle_series).re

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.GRAY, false, 1.0)
	if show_parts:
		var color := Color(Color.LIGHT_GREEN, 0.5)
		for i in range(0, cycle_series_size):
			var cycle : SpectrumData = cycle_series[i]
			if i != 0:
				color = Color.DARK_GREEN
			draw_line(Vector2.ZERO, Vector2(cycle.re, cycle.im), color, 1)
	#if show_combined:
		#FourierTransform.total_value(0, )

		#timegraph_path(cycle_func, Color.DARK_GRAY)

func cyclegraph_circle(cycle_callable:Callable, color:Color = Color.GRAY, line_width:float = 1.0):
	var px = 0
	var py = 0
	var prev_point : Vector2 = Vector2.ZERO
	var curr_point : Vector2 = Vector2.ZERO

	for i in range(0, radius):
		var x = 2 * PI * i / float(radius)
		var y = cycle_callable.call(x)
		prev_point = curr_point
		px = x * ((180 / PI) * radius / 360) - (radius / 2.0)
		py = -radius * (y / max_y)
		if is_nan(py):
			continue
		curr_point = Vector2(px, py)

		if (i == 0):
			continue
		else:
			draw_line(prev_point, curr_point, color, line_width)
