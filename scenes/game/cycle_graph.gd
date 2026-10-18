extends Node2D

@export var cycle_series : Array :
	set(value):
		cycle_series = value
		cycle_series_size = cycle_series.size()
		max_y = 0
		for i in range(0, radius):
			var x = 2 * PI * i / float(radius)
			var y = cycle_func(x).re
			max_y = max(y, max_y)
			y_values.append(y)
		queue_redraw()

@export var radius : float = 120
@export var show_parts : bool = true
@export var show_combined : bool = true
@export var combined_color : Color = Color.DARK_GRAY
@export var combined_line_width : float = 1.0
@export var first_part_color : Color = Color(Color.LIGHT_GREEN, 0.25)
@export var other_part_color : Color = Color.DARK_GREEN
@export var part_line_width : float = 1.0
@export var ticks_color : Color = Color(Color.YELLOW, 0.25)

var cycle_series_size : int = 0
var y_values : Array[float]
var max_y : float = 0

@onready var total_check_box = %TotalCheckBox
@onready var parts_check_box = %PartsCheckBox
@onready var ticks_check_box = %TicksCheckBox

func cycle_func(x:float) -> SpectrumData:
	return FourierTransform.total_value(x, cycle_series)

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 1.0)
	if show_parts:
		var color := Color(Color.LIGHT_GREEN, 0.5)
		for i in range(0, cycle_series_size):
			var cycle : SpectrumData = cycle_series[i]
			var cycle_radius = cycle.amp * radius / max_y
			if i != 0:
				color = Color.DARK_GREEN
			draw_circle(Vector2.ZERO, cycle_radius, color, false, part_line_width)
	if show_combined:
		cyclegraph_circle(int(radius), combined_color, combined_line_width)


func cyclegraph_circle(points:int, color:Color = Color.GRAY, line_width:float = 1.0):
	var px = 0
	var py = 0
	var prev_point : Vector2 = Vector2.ZERO
	var curr_point : Vector2 = Vector2.ZERO

	for i in range(0, points):
		var point = 2 * PI * i / float(points)
		var x = cycle_func.call(point).re
		var y = -cycle_func.call(point).im
		prev_point = curr_point
		curr_point = Vector2(x, y)
		curr_point *= radius / max_y
		if (i == 0):
			continue
		else:
			draw_line(prev_point, curr_point, color, line_width)
