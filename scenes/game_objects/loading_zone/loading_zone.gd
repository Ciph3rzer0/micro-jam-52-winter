extends Node3D
class_name LoadingZone

signal loading_complete()
signal loading_incomplete()

@export var clear_automatically: bool = true
@export var clear_delay: float = 5.0

var fully_loaded: bool = false
var clear_countdown: float = clear_delay
var loading_slots: Array[LoadingSlot] = []

const AUDIO_JINGLE_ACQUIRED = preload("res://assets/audio/sfx/jingle-acquired.mp3")
var audio_player: AudioStreamPlayer


func _ready() -> void:
	%DeliveryProgressWidget.visible = false

	for child in %LoadingSlots.get_children():
		if child is LoadingSlot:
			loading_slots.append(child)

func _process(delta: float) -> void:
	# CRASHES GAME ON LAUNCH, UNKNOWN BUG, TEMP REMOVAL
	if owner.loading_zones_unload_blocks():
		if check_all_filled():
			if clear_automatically:
				clear_countdown -= delta
				if clear_countdown <= 0.0:
					clear_countdown = clear_delay
					clear_loading_zone()
		else:
			clear_countdown = clear_delay
	
		if fully_loaded:
			var progress := clampf(clear_delay - clear_countdown, 0.0, clear_delay) / clear_delay
			%DeliveryProgressBar.value = progress * 100.0
	
		%DeliveryProgressWidget.visible = fully_loaded


func check_all_filled() -> bool:
	var slots_filled := 0

	for slot in loading_slots:
		if slot.is_filled:
			slots_filled += 1

	if not fully_loaded and slots_filled == loading_slots.size():
		set_loading_zone_full_state(true)
		print("All loading slots filled!")
		return true
	elif fully_loaded and slots_filled < loading_slots.size():
		set_loading_zone_full_state(false)
		print("Loading slots no longer all filled.")
		return false

	return slots_filled == loading_slots.size()


func clear_loading_zone() -> void:
	print("Clearing loading zone...")
	for slot in loading_slots:
		var object := LevelGrid.get_object_at_position(slot.current_position)
		if object != null and object.owner.is_in_group("box"):
			print("Removing box at position: ", slot.current_position)
			object.owner.collect_box()
			owner.score_a_box()
			
			if audio_player == null:
				audio_player = AudioStreamPlayer.new()
				add_child(audio_player)
				audio_player.stream = AUDIO_JINGLE_ACQUIRED
				
			if not audio_player.playing:
				audio_player.play()
				
			var foreman = get_tree().get_first_node_in_group("foreman")
			if foreman and foreman.has_method("play_victory_animation"):
				foreman.play_victory_animation()

		else:
			assert(false, "Expected a box at loading zone position: %s" % slot.current_position)
	%DeliveryProgressWidget.visible = false


func set_loading_zone_full_state(state: bool) -> void:
	fully_loaded = state
	if state:
		loading_complete.emit()
	else:
		loading_incomplete.emit()
