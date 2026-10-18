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
@export var base_drawing_speed:float = 1.0

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
var processing_data_points : int = 0
var processing_key : int = 0

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
			base_processing_speed *= 5.0
			base_drawing_speed *= 5.0
			data_points_h_slider.max_value *= 10
		"part_2":
			base_processing_speed *= 5.0
			base_drawing_speed *= 10.0
			data_points_h_slider.max_value *= 15

func _on_dialogue_ended(_dialogue_resource):
	if current_dialogue_name == "ending":
		animation_player.play(&"ending")

func _ready():
	var fourier_x :Array[SpectrumData] = homer_simpson_transform.get_fourier_x()
	fourier_cycles.data = fourier_x
	processing_data_points = 1
	_process_data_points()
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	_play_next_dialogue()

func _on_process_button_pressed():
	is_signal_processing = true
	process_button.disabled = is_signal_processing
	data_points_h_slider.editable = not is_signal_processing
	processing_data_points = data_points_h_slider.value
	processing_key = option_button.selected

func _process_data_points() -> void:
	fourier_cycles.radius_mode = processing_key
	fourier_cycles.time_mod = draw_speed_h_slider.value * base_drawing_speed / float(processing_data_points)
	fourier_cycles.terms = processing_data_points

func _process(delta):
	if not is_signal_processing: return
	processing_progress += delta * base_processing_speed / float(processing_data_points)
	progress_bar.value = processing_progress
	if processing_progress >= 1.0:
		_process_data_points()
		is_signal_processing = false
		process_button.disabled = is_signal_processing
		data_points_h_slider.editable = not is_signal_processing
		processing_progress = 0.0

func _on_data_points_h_slider_value_changed(value):
	data_points_text.text = "%d" % value

func _on_draw_speed_h_slider_value_changed(value):
	fourier_cycles.time_mod = draw_speed_h_slider.value * base_drawing_speed

func _on_fourier_cycles_drawing_completed():
	match(current_dialogue_name):
		"start":
			if processing_data_points >= 4:
				if processing_key == 3:
					_play_next_dialogue()
				else:
					if is_instance_valid(current_dialogue_balloon):
						current_dialogue_balloon.queue_free()
					current_dialogue_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, "incorrect")
		"part_1":
			if processing_data_points >= 40 and processing_key == 3:
				_play_next_dialogue()
		"part_2":
			if processing_data_points >= 250 and processing_key == 3:
				_play_next_dialogue()

func _on_animation_player_animation_finished(anim_name):
	level_won.emit()
