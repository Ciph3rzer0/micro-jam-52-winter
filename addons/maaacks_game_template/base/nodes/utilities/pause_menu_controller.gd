extends Node

## Node for opening a pause menu when detecting a 'ui_cancel' event.

@onready var bgm: AudioStreamPlayer = $"../BackgroundMusicPlayer"
@export var pause_menu_packed: PackedScene
@export var focused_viewport: Viewport

var pause_menu: Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# turn audio back on if it's off
		# turn audio back on if it's off
		var should_play_music := true
		var current_level_path = GameState.get_current_level_path()
		if "8_the_factory" in current_level_path:
			should_play_music = false
		
		if should_play_music:
			if bgm.playing:
				print("bgm playing")
			else:
				bgm.play()
			
		# original ui_cancel function 
		if pause_menu.visible: return
		if not focused_viewport:
			focused_viewport = get_viewport()
		var _initial_focus_control = focused_viewport.gui_get_focus_owner()
		pause_menu.show()
		if pause_menu is CanvasLayer:
			await pause_menu.visibility_changed
		else:
			await pause_menu.hidden
		if is_inside_tree() and _initial_focus_control:
			_initial_focus_control.grab_focus()

func _ready() -> void:
	pause_menu = pause_menu_packed.instantiate()
	pause_menu.hide()
	get_tree().current_scene.call_deferred("add_child", pause_menu)
