extends "./level.gd"

var animations : Array[StringName]= [
	&'part_1',
	&'part_2',
	&'part_3',
	&'part_3_5',
	&'part_4',
	&'part_5',
	&'part_6',
	&'part_7',
	&'part_8',
]

var current_animation_iter : int = -1
var current_animation_name : String = ""
var current_dialogue_balloon : Node
@export var dialogue_resource : DialogueResource
@onready var animation_player = %AnimationPlayer

func _load_next_scene() -> void:
	level_won.emit()

func _on_animation_player_animation_finished(anim_name):
	if current_animation_name == anim_name:
		_play_next_slide()
	
func _event_skips_intro(event : InputEvent) -> bool:
	return event.is_action_pressed(&"ui_cancel")

func _unhandled_input(event : InputEvent) -> void:
	if _event_skips_intro(event):
		_load_next_scene()

func _play_next_slide() -> void:
	current_animation_iter += 1
	if current_animation_iter >= animations.size():
		_load_next_scene()
		return
	current_animation_name = animations[current_animation_iter]
	animation_player.play(current_animation_name)
	if is_instance_valid(current_dialogue_balloon):
		current_dialogue_balloon.queue_free()
	current_dialogue_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, current_animation_name)

func _on_dialogue_ended(_dialogue_resource):
	_play_next_slide()

func _ready():
	_play_next_slide()
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
