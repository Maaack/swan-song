extends Node2D

@export var cycle_series : Array :
	set(value):
		cycle_series = value
		cycle_series_size = cycle_series.size()
		for i in range(0, width):
			var x = 2 * PI * i / float(width)
			var y = cycle_func(x)
			max_y = max(y, max_y)
			y_values.append(y)

		queue_redraw()

@export var height : float = 120
@export var width : float = 800
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
	if show_parts:
		var color := Color(Color.LIGHT_GREEN, 0.5)
		for i in range(0, cycle_series_size):
			if i != 0:
				color = Color.DARK_GREEN
			timegraph_path(func(x): return FourierTransform.total_value(x, [cycle_series[i]]).re, color)
	if show_combined:
		timegraph_path(cycle_func, Color.DARK_GRAY)

func timegraph_path(cycle_callable:Callable, color:Color = Color.GRAY, line_width:float = 1.0):
	var px = 0
	var py = 0
	var prev_point : Vector2 = Vector2.ZERO
	var curr_point : Vector2 = Vector2.ZERO

	for i in range(0, width):
		var x = 2 * PI * i / float(width)
		var y = cycle_callable.call(x)
		prev_point = curr_point
		px = x * ((180 / PI) * width / 360) - (width / 2.0)
		py = -height * (y / max_y)
		if is_nan(py):
			continue
		curr_point = Vector2(px, py)

		if (i == 0):
			continue
		else:
			draw_line(prev_point, curr_point, color, line_width)

func timegraph_interval(t, color):
	var x = (t * 180 / PI) * width / 360
	var min_y = height / 2
	var max_y = -height / 2
