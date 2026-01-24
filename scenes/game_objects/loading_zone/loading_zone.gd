extends Node3D

var loading_slots: Array[DiscretePosition] = []

func _ready() -> void:
	for child in get_children():
		loading_slots.append(DiscretePosition.new(child))

func _process(_delta: float) -> void:
	if check_win_condition():
		print("Loading complete!")

func check_win_condition() -> bool:
	var slots_filled := 0

	for slot in loading_slots:
		var object := LevelGrid.get_object_at_position(slot.current_position)
		# if object != null:
		# 	print("Name: %s at loading slot %s" % [object.owner.name, slot.current_position])
		if object and not object.is_moving:
			slots_filled += 1
	
	print("Loading slots filled: %d / %d" % [slots_filled, loading_slots.size()])

	return slots_filled == loading_slots.size()
			
