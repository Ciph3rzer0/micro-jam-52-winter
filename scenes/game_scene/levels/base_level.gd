
extends Node
class_name LevelScript


@warning_ignore_start("unused_signal")
signal level_lost
signal level_won(level_path : String)
signal level_changed(level_path : String)
@warning_ignore_restore("unused_signal")


@onready var loading_zones := get_tree().get_nodes_in_group("loading_zone")


@export_category("Win Conditions")
@export var blocks_to_win: int = 0
var collected_blocks: int = 0

@export var time_limit_seconds: float = 0.0
var time_elapsed_seconds: float = 0.0


func loading_zones_unload_blocks() -> bool:
	return blocks_to_win > 0


var level_state : LevelState


func _init() -> void:
	LevelGrid.clear_grid()


func _ready() -> void:
	level_state = GameState.get_level_state(scene_file_path)
	%TimeUI.visible = time_limit_seconds > 0.0
	%ScoreUI.visible = blocks_to_win > 0.0
	# %ColorPickerButton.color = level_state.color
	# %BackgroundColor.color = level_state.color
	# if not level_state.tutorial_read:
	# 	open_tutorials()


func _process(_delta: float) -> void:
	# CHEATS
	if Input.is_key_pressed(Key.KEY_C):
		if Input.is_key_pressed(Key.KEY_G):
			process_mode = Node.PROCESS_MODE_DISABLED
			level_won.emit()
		if Input.is_key_pressed(Key.KEY_H):
			process_mode = Node.PROCESS_MODE_DISABLED
			level_lost.emit()

	if time_limit_seconds > 0.0:
		time_elapsed_seconds += _delta
		if has_node("%TimeLeft"):
			%TimeLeft.text = "%.2f" % max(time_limit_seconds - time_elapsed_seconds, 0)
		if time_elapsed_seconds >= time_limit_seconds:
			process_mode = Node.PROCESS_MODE_DISABLED
			level_lost.emit()

	if blocks_to_win <= 0:
		for loading_zone in loading_zones:
			if not loading_zone.check_all_filled():
				return
	
		process_mode = Node.PROCESS_MODE_DISABLED
		level_won.emit()


func score_a_box() -> void:
	collected_blocks += 1
	%Score.text = str(collected_blocks)
	GlobalState.save()

	if blocks_to_win > 0:
		print("Collected blocks: %d / %d" % [collected_blocks, blocks_to_win])
		if collected_blocks >= blocks_to_win:
			process_mode = Node.PROCESS_MODE_DISABLED
			level_won.emit()


# func _on_color_picker_button_color_changed(color : Color) -> void:
	# %BackgroundColor.color = color
	# level_state.color = color
	# GlobalState.save()


func _on_tutorial_button_pressed() -> void:
	open_tutorials()


func open_tutorials() -> void:
	%TutorialManager.open_tutorials()
	level_state.tutorial_read = true
	GlobalState.save()
