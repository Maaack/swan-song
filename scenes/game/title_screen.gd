extends Control

## If Maaack's Scene Loader is installed, then it will be used to change scenes.
@onready var scene_loader_node = get_tree().root.get_node_or_null(^"SceneLoader")

## Requires Maaack's Scene Loader.
@export var show_loading_screen : bool = false

func get_next_scene_path() -> String:
	return MaaacksGameTemplate.get_game_path()

func _on_scene_loaded() -> void:
	scene_loader_node.change_scene_to_resource()

func _load_next_scene() -> void:
	if scene_loader_node:
		var status = scene_loader_node.get_status()
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			_on_scene_loaded()
		elif show_loading_screen:
			scene_loader_node.change_scene_to_loading_screen()
		elif not scene_loader_node.scene_loaded.is_connected(_on_scene_loaded):
			scene_loader_node.scene_loaded.connect(_on_scene_loaded, CONNECT_ONE_SHOT)
	else:
		get_tree().change_scene_to_file(get_next_scene_path())

func _on_animation_player_animation_finished(_anim_name):
	_load_next_scene()
	
func _event_skips_intro(event : InputEvent) -> bool:
	return event.is_action_pressed(&"ui_cancel")

func _unhandled_input(event : InputEvent) -> void:
	if _event_skips_intro(event):
		_load_next_scene()

func _ready() -> void:
	if scene_loader_node:
		scene_loader_node.load_scene(get_next_scene_path(), true)
