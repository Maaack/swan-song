extends "./level.gd"

var dialogues : Array[StringName]= [
	&'start',
	&'part_1',
	&'part_2',
	&'ending',
]

var current_dialogue_iter : int = -1
var current_dialogue_name : String = ""
var current_dialogue_balloon : Node

@export var dialogue_resource : DialogueResource
@export var base_processing_speed:float = 1.0

@onready var homer_simpson_transform = %HomerSimpsonTransform
@onready var fourier_cycles = %FourierCycles
@onready var data_points_text = %DataPointsText
@onready var process_button = %ProcessButton
@onready var progress_bar = %ProgressBar
@onready var data_points_h_slider = %DataPointsHSlider
@onready var draw_speed_h_slider = %DrawSpeedHSlider
@onready var animation_player = %AnimationPlayer
@onready var option_button = %OptionButton

var is_signal_processing : bool = false
var processing_progress : float = 0.0

func _play_next_dialogue() -> void:
	current_dialogue_iter += 1
	if current_dialogue_iter >= dialogues.size():
		level_won.emit()
		return
	current_dialogue_name = dialogues[current_dialogue_iter]
	if is_instance_valid(current_dialogue_balloon):
		current_dialogue_balloon.queue_free()
	current_dialogue_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, current_dialogue_name)
	match(current_dialogue_name):
		"part_1":
			base_processing_speed *= 8.0
			data_points_h_slider.max_value *= 10
		"part_2":
			base_processing_speed *= 10.0
			data_points_h_slider.max_value *= 15

func _on_dialogue_ended(_dialogue_resource):
	if current_dialogue_name == "ending":
		animation_player.play(&"ending")

func _ready():
	var fourier_x :Array[SpectrumData] = homer_simpson_transform.get_fourier_x()
	fourier_cycles.data = fourier_x
	fourier_cycles.terms = 1
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	_play_next_dialogue()

func _on_process_button_pressed():
	is_signal_processing = true
	process_button.disabled = is_signal_processing
	data_points_h_slider.editable = not is_signal_processing

func _process_data_points(value:int) -> void:
	fourier_cycles.radius_mode = option_button.selected
	fourier_cycles.terms = value

func _process(delta):
	if not is_signal_processing: return
	var signal_parts : int = data_points_h_slider.value
	processing_progress += delta * base_processing_speed / float(signal_parts)
	progress_bar.value = processing_progress
	if processing_progress >= 1.0:
		_process_data_points(signal_parts)
		is_signal_processing = false
		process_button.disabled = is_signal_processing
		data_points_h_slider.editable = not is_signal_processing
		processing_progress = 0.0

func _on_data_points_h_slider_value_changed(value):
	data_points_text.text = "%d" % value

func _on_draw_speed_h_slider_value_changed(value):
	fourier_cycles.time_mod = draw_speed_h_slider.value

func _on_fourier_cycles_drawing_completed():
	match(current_dialogue_name):
		"start":
			if data_points_h_slider.value >= 4 and option_button.selected == 3:
				_play_next_dialogue()
		"part_1":
			if data_points_h_slider.value >= 40 and option_button.selected == 3:
				_play_next_dialogue()
		"part_2":
			if data_points_h_slider.value >= 250 and option_button.selected == 3:
				_play_next_dialogue()

func _on_animation_player_animation_finished(anim_name):
	level_won.emit()
