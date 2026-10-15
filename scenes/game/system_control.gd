extends Control

@export var graph_scale:float = 1.0
@onready var graph = %Graph
@onready var cycle_series_input = %CycleSeriesInput
@onready var time_series_input = %TimeSeriesInput

func parse_time_series(input:String) -> PackedFloat64Array:
	return input.split_floats(" ", false)

func parse_cycle_series(input:String) -> Array:
	var parsed_cycles : Array = []
	var splits := input.split(" ")
	var index : int = 0
	for split in splits:
		var parts = split.split(":")
		var amp := parts[0] as float
		var phase := 0.0
		if parts.size() > 1:
			phase = parts[1]
		var value = SpectrumData.new(0, 0, index, amp, phase)
		parsed_cycles.append(value)
		index += 1
	return parsed_cycles

func _on_time_series_input_text_submitted(new_text:String):
	var time_series = parse_time_series(new_text)
	var cycle_series = FourierTransform.dft(time_series)
	graph.cycle_series = cycle_series
	graph.queue_redraw()

func _on_cycle_series_input_text_submitted(new_text):
	var parsed_cycles = parse_cycle_series(new_text)
	var time_series = FourierTransform.idft(parsed_cycles)
	time_series_input.text = " ".join(time_series)
	var cycle_series = FourierTransform.dft(time_series)
	graph.cycle_series = cycle_series
	graph.queue_redraw()

func _on_total_check_box_toggled(toggled_on):
	graph.show_combined = toggled_on
	graph.queue_redraw()

func _on_parts_check_box_toggled(toggled_on):
	graph.show_parts = toggled_on
	graph.queue_redraw()
