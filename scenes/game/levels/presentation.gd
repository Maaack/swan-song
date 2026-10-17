extends "./level.gd"

var animations : Array[StringName]= [
	&'part_1',
	&'part_2',
	&'part_3',
	&'part_4',
]

var current_animation_iter : int = -1
@export var dialogue_resource : DialogueResource
@onready var animation_player = %AnimationPlayer

func _load_next_scene() -> void:
	level_won.emit()

func _on_animation_player_animation_finished(_anim_name):
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
	var current_animation := animations[current_animation_iter]
	animation_player.play(current_animation)
	DialogueManager.show_dialogue_balloon(dialogue_resource, current_animation)

func _ready():
	_play_next_slide()
