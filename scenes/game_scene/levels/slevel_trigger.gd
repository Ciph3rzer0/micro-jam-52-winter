extends Node3D

var loading_zones: Array[Node3D] = []

func _ready() -> void:
	print("Level Trigger Ready")
	for child in get_children():
		if child.is_in_group("loading_zone"):
			loading_zones.append(child)

func _process(delta: float) -> void:
	print("Checking win condition...")
	if check_win_condition():
		print("Level Complete!")

func check_win_condition() -> bool:
	for zone in loading_zones:
		print("Checking loading zone: %s" % zone.name)
		if not zone.fully_loaded:
			return false
	return true
