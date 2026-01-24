extends Node3D

signal loading_complete()
signal loading_incomplete()

var fully_loaded: bool = false
var loading_slots: Array[DiscretePosition] = []

func _ready() -> void:
	for child in get_children():
		(child.get_child(0) as MeshInstance3D).material_override = StandardMaterial3D.new()
		loading_slots.append(DiscretePosition.new(child))

func _process(_delta: float) -> void:
	if check_win_condition():
		pass

func check_win_condition() -> bool:
	var slots_filled := 0

	for slot in loading_slots:
		var object := LevelGrid.get_object_at_position(slot.current_position)
		if object != null:
			# 	print("Name: %s at loading slot %s" % [object.owner.name, slot.current_position])
			if not object.is_moving and object.owner.is_in_group("box"):
				slots_filled += 1
				(slot.owner.get_child(0) as MeshInstance3D).material_override.albedo_color = Color(0, 1, 0)  # Change color to green when in loading zone
			else:
				(slot.owner.get_child(0) as MeshInstance3D).material_override.albedo_color = Color(1, 1, 1)  # Reset color if not in loading zone
	
	# print("Loading slots filled: %d / %d" % [slots_filled, loading_slots.size()])

	if not fully_loaded and slots_filled == loading_slots.size():
		fully_loaded = true
		loading_complete.emit()
		print("All loading slots filled!")
		return true
	elif fully_loaded and slots_filled < loading_slots.size():
		fully_loaded = false
		loading_incomplete.emit()
		print("Loading slots no longer all filled.")
		return false

	return slots_filled == loading_slots.size()
			
