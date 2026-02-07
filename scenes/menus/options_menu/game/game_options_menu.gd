extends Control


func _ready() -> void:
	var timer_difficulty = PlayerConfig.get_config("GameSettings", "timer_difficulty", 0)
	%TimerOptions.selected = timer_difficulty
	
	%SpeedOptions.set_item_metadata(0, 1.0)
	%SpeedOptions.set_item_metadata(1, 0.7)
	_set_player_speed_option()


func _set_player_speed_option() -> void:
	var player_speed = PlayerConfig.get_config("GameSettings", "player_speed", 1.0)

	%SpeedOptions.selected = 0
	for i in %SpeedOptions.item_count:
		var speed = %SpeedOptions.get_item_metadata(i)
		if speed == player_speed:
			%SpeedOptions.selected = i
			break


func _on_ResetGameControl_reset_confirmed() -> void:
	GameState.reset()


func _on_timer_options_item_selected(index: int) -> void:
	PlayerConfig.set_config("GameSettings", "timer_difficulty", index)


func _on_speed_options_item_selected(index: int) -> void:
	var player_speed = %SpeedOptions.get_item_metadata(index)
	print("Setting player speed to ", player_speed)
	GameState.player_speed_modifier = player_speed
	PlayerConfig.set_config("GameSettings", "player_speed", player_speed)
