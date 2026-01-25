
extends Node
class_name LevelScript

@warning_ignore("unused_signal")
signal level_lost
signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)

func _init() -> void:
	LevelGrid.clear_grid()

@onready var loading_zones := get_tree().get_nodes_in_group("loading_zone")

# ## Optional path to the next level if using an open world level system.
# @export_file("*.tscn") var next_level_path : String

var level_state : LevelState


func open_tutorials() -> void:
	%TutorialManager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()

func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	# %ColorPickerButton.color = level_state.color
	# %BackgroundColor.color = level_state.color
	# if not level_state.tutorial_read:
	# 	open_tutorials()


func _process(_delta: float) -> void:
	for loading_zone in loading_zones:
		if not loading_zone.check_win_condition():
			return
	
	process_mode = Node.PROCESS_MODE_DISABLED
	level_won.emit()

# func _on_color_picker_button_color_changed(color : Color) -> void:
	# %BackgroundColor.color = color
	# level_state.color = color
	# GlobalState.save()

func _on_tutorial_button_pressed() -> void:
	open_tutorials()
