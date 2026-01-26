extends Control

@onready var background_music_player: AudioStreamPlayer = $BackgroundMusicPlayer
@onready var level_loader: LevelLoader = $LevelLoader

func _ready() -> void:
	level_loader.level_loaded.connect(_on_level_loaded)

func _on_level_loaded() -> void:
	var current_level_path = GameState.get_current_level_path()
	# Checking the file name directly to avoid hardcoding UIDs which might change or be less readable
	if "8_the_factory" in current_level_path:
		background_music_player.stop()
	else:
		if not background_music_player.playing:
			background_music_player.play()
