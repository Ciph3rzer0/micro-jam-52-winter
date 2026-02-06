
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
var modified_time_limit_seconds: float = 0.0
var time_elapsed_seconds: float = 0.0

const RELOAD_HOLD_TIME := 1.1
const RELOAD_UI_LINGER := 0.5
var reload_pressed := false
var reload_hold_timer := -RELOAD_UI_LINGER

func loading_zones_unload_blocks() -> bool:
	return blocks_to_win > 0


var level_state : LevelState


func _init() -> void:
	LevelGrid.clear_grid()


func _ready() -> void:
	match PlayerConfig.get_config("GameSettings", "timer_difficulty", 0):
		0:
			modified_time_limit_seconds = time_limit_seconds
		1:
			modified_time_limit_seconds = time_limit_seconds * 1.5
		2:
			modified_time_limit_seconds = 0

	level_state = GameState.get_level_state(scene_file_path)
	%TimeUI.visible = modified_time_limit_seconds > 0.0
	%ScoreUI.visible = blocks_to_win > 0.0
	# %ColorPickerButton.color = level_state.color
	# %BackgroundColor.color = level_state.color
	# if not level_state.tutorial_read:
	# 	open_tutorials()


func _process(_delta: float) -> void:
	# This makes sure the reload doesn't trigger on the reloaded scene
	# (only after the button is released and pressed again in the new scene)
	if Input.is_action_just_pressed("reload_level"):
		reload_pressed = true

	if reload_pressed and Input.is_action_pressed("reload_level"):
		reload_hold_timer = max(reload_hold_timer, 0.0)
		reload_hold_timer += _delta
		if reload_hold_timer >= RELOAD_HOLD_TIME:
			print("Reloading level...")
			reload_pressed = false
			SceneLoader.reload_current_scene()
	else:
		reload_hold_timer = max(-RELOAD_UI_LINGER, reload_hold_timer - _delta * 4.0)
	
	%RestartUI.visible = reload_hold_timer > -RELOAD_UI_LINGER
	%RestartProgressBar.value = ease(reload_hold_timer / RELOAD_HOLD_TIME, 0.4) * 100.0


	# CHEATS
	if Input.is_key_pressed(Key.KEY_C):
		if Input.is_key_pressed(Key.KEY_G):
			process_mode = Node.PROCESS_MODE_DISABLED
			level_won.emit()
		if Input.is_key_pressed(Key.KEY_H):
			process_mode = Node.PROCESS_MODE_DISABLED
			level_lost.emit()

	if modified_time_limit_seconds > 0.0:
		time_elapsed_seconds += _delta
		if has_node("%TimeLeft"):
			%TimeLeft.text = "%.2f" % max(modified_time_limit_seconds - time_elapsed_seconds, 0)
		if time_elapsed_seconds >= modified_time_limit_seconds:
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
