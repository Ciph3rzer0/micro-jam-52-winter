extends Control


func _ready() -> void:
	var timer_difficulty = PlayerConfig.get_config("GameSettings", "timer_difficulty", 0)
	%TimerOptions.selected = timer_difficulty


func _on_ResetGameControl_reset_confirmed() -> void:
	GameState.reset()


func _on_timer_options_item_selected(index: int) -> void:
	PlayerConfig.set_config("GameSettings", "timer_difficulty", index)
