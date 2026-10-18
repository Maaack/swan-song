extends Node
@onready var level_loader = $LevelLoader
@onready var background_music_player = $BackgroundMusicPlayer

func _on_level_loader_level_loaded():
	if level_loader.current_level_path.get_file() == "title_screen.tscn":
		background_music_player.stop()
	elif not background_music_player.playing:
		background_music_player.play()
