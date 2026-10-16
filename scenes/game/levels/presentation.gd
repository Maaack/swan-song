extends "./level.gd"

func _load_next_scene() -> void:
	level_won.emit()

func _on_animation_player_animation_finished(_anim_name):
	_load_next_scene()
	
func _event_skips_intro(event : InputEvent) -> bool:
	return event.is_action_pressed(&"ui_cancel")

func _unhandled_input(event : InputEvent) -> void:
	if _event_skips_intro(event):
		_load_next_scene()
