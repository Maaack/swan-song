extends Control

@export var graph_scale:float = 1.0
@onready var graph = %Graph

func parse_time_series(input:String) -> PackedFloat64Array:
	return input.split_floats(" ", false)

func _on_time_series_input_text_submitted(new_text:String):
	var time_series = parse_time_series(new_text)
	var cycle_series = FourierTransform.dft(time_series)
	graph.cycle_series = cycle_series
	graph.queue_redraw()

func _on_total_check_box_toggled(toggled_on):
	graph.show_combined = toggled_on
	graph.queue_redraw()

func _on_parts_check_box_toggled(toggled_on):
	graph.show_parts = toggled_on
	graph.queue_redraw()
