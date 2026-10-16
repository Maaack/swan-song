extends Control

@export var graph_scale:float = 1.0
@onready var time_graph = %TimeGraph
@onready var cycle_graph = %CycleGraph
@onready var cycle_series_input = %CycleSeriesInput
@onready var time_series_input = %TimeSeriesInput
@onready var signal_splits = %SignalSplits
@onready var result_text = %ResultText

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

func _draw_graphs():
	time_graph.queue_redraw()
	cycle_graph.queue_redraw()

func _draw_cycle_series(cycle_series:Array[SpectrumData]):
	time_graph.cycle_series = cycle_series
	cycle_graph.cycle_series = cycle_series

func _on_time_series_input_text_submitted(new_text:String):
	var time_series = parse_time_series(new_text)
	var cycle_series = FourierTransform.dft(time_series)
	_draw_cycle_series(cycle_series)

func _on_cycle_series_input_text_submitted(new_text):
	var parsed_cycles = parse_cycle_series(new_text)
	var time_series = FourierTransform.idft(parsed_cycles)
	time_series_input.text = " ".join(time_series)
	var cycle_series = FourierTransform.dft(time_series)
	_draw_cycle_series(cycle_series)

func _on_total_check_box_toggled(toggled_on):
	time_graph.show_combined = toggled_on
	cycle_graph.show_combined = toggled_on

func _on_parts_check_box_toggled(toggled_on):
	time_graph.show_parts = toggled_on
	cycle_graph.show_combined = toggled_on

func _on_signal_splits_value_changed(value):
	var cycle_series = time_graph.cycle_series
	var cycle_series_size = cycle_series.size()
	var text = ""
	for i in range(0, value):
		var x = 2 * PI * i / float(value)
		text += "%0.1f  " % FourierTransform.total_value(x, cycle_series).amp
	result_text.text = text
