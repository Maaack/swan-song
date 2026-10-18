extends "./level.gd"

@export var dialogue_resource : DialogueResource
@export var graph_scale:float = 1.0
@export var base_processing_speed:float = 1.0

@onready var time_graph = %TimeGraph
@onready var cycle_graph = %CycleGraph
@onready var cycle_series_input = %CycleSeriesInput
@onready var time_series_input = %TimeSeriesInput
@onready var signal_splits = %SignalSplits
@onready var result_text = %ResultText
@onready var original_time_graph = %OriginalTimeGraph
@onready var process_button = %ProcessButton
@onready var progress_bar = %ProgressBar

var is_signal_processing : bool = false
var processing_progress : float = 0.0

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

func _process_original_time_series(text:String):
	var time_series = parse_time_series(text)
	var cycle_series = FourierTransform.dft(time_series)
	original_time_graph.cycle_series = cycle_series

func _process_test_time_series(text:String):
	var time_series = parse_time_series(text)
	var cycle_series = FourierTransform.dft(time_series)
	_draw_cycle_series(cycle_series)

func _on_time_series_input_text_submitted(new_text:String):
	_process_original_time_series(new_text)

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

func _parse_and_process_signal_parts(value:int):
	var cycle_series = original_time_graph.cycle_series
	var cycle_series_size = cycle_series.size()
	var text = ""
	for i in range(0, value):
		var x = 2 * PI * i / float(value)
		text += "%0.1f  " % FourierTransform.total_value(x, cycle_series).amp
	result_text.text = text
	_process_test_time_series(text)

func _on_continue_button_pressed():
	DialogueManager.show_dialogue_balloon(dialogue_resource, &"start")
	await DialogueManager.dialogue_ended
	level_won.emit()

func _ready():
	_process_original_time_series("2 3 5 7 11 13 17 19 23")


func _on_process_button_pressed():
	is_signal_processing = true
	process_button.disabled = is_signal_processing
	signal_splits.editable = not is_signal_processing
	

func _process(delta):
	if not is_signal_processing: return
	var signal_parts : int = signal_splits.value
	processing_progress += delta * base_processing_speed / float(signal_parts)
	progress_bar.value = processing_progress
	if processing_progress >= 1.0:
		_parse_and_process_signal_parts(signal_parts)
		is_signal_processing = false
		process_button.disabled = is_signal_processing
		signal_splits.editable = not is_signal_processing
		processing_progress = 0.0
