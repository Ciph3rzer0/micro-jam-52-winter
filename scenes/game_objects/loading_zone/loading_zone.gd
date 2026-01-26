extends Node3D

const COLOR_ACTIVE: Color = Color(0, 1, 0)  # Green
const COLOR_INACTIVE: Color = Color(1, 1, 1)  # White

signal loading_complete()
signal loading_incomplete()

@export var clear_automatically: bool = true
@export var clear_delay: float = 5.0

var fully_loaded: bool = false
var clear_countdown: float = clear_delay
var loading_slots: Array[DiscretePosition] = []


func _ready() -> void:
	%DeliveryProgressWidget.visible = false

	for child in %LoadingSlots.get_children():
		(child.get_child(0) as MeshInstance3D).material_override = StandardMaterial3D.new()
		loading_slots.append(DiscretePosition.new(child))


func _process(delta: float) -> void:
	if owner.loading_zones_unload_blocks():
		if check_all_filled():
			if clear_automatically and owner.loading_zones_unload_blocks():
				clear_countdown -= delta
				if clear_countdown <= 0.0:
					clear_countdown = clear_delay
					clear_loading_zone()
		else:
			clear_countdown = clear_delay
	
		if fully_loaded:
			var progress := clampf(clear_delay - clear_countdown, 0.0, clear_delay) / clear_delay
			%DeliveryProgressBar.value = progress * 100.0
			
			for slot in loading_slots:
				(slot.owner.get_child(0) as MeshInstance3D).material_override.albedo_color \
				= COLOR_ACTIVE.lerp(COLOR_INACTIVE, (sin(Time.get_ticks_msec() / 100.0) * 0.5 + 0.5))
	
		%DeliveryProgressWidget.visible = fully_loaded


func check_all_filled() -> bool:
	var slots_filled := 0

	for slot in loading_slots:
		var object := LevelGrid.get_object_at_position(slot.current_position)
		if object != null:
			# 	print("Name: %s at loading slot %s" % [object.owner.name, slot.current_position])
			if not object.is_moving and object.owner.is_in_group("box"):
				slots_filled += 1
				set_slot_filled_state(slot.owner.get_child(0) as MeshInstance3D, true)
			else:
				set_slot_filled_state(slot.owner.get_child(0) as MeshInstance3D, false)
		else:
			set_slot_filled_state(slot.owner.get_child(0) as MeshInstance3D, false)
	
	# print("Loading slots filled: %d / %d" % [slots_filled, loading_slots.size()])

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
		else:
			assert(false, "Expected a box at loading zone position: %s" % slot.current_position)
	%DeliveryProgressWidget.visible = false


func set_slot_filled_state(slot: MeshInstance3D, filled: bool) -> void:
	if filled:
		slot.material_override.albedo_color = COLOR_ACTIVE
	else:
		slot.material_override.albedo_color = COLOR_INACTIVE


func set_loading_zone_full_state(state: bool) -> void:
	fully_loaded = state
	if state:
		loading_complete.emit()
	else:
		loading_incomplete.emit()
