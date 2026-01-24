extends Node

var cells = {}

func _ready() -> void:
	pass

func add_object_to_cell(position: Vector3i, cell_node: Node3D) -> void:
	if not cells.has(position):
		cells[position] = cell_node

func move_object_to_cell(node: Node3D, relative_motion: Vector3i) -> void:
	if relative_motion.length() != 1:
		printerr("Relative motion must be to an adjacent cell.")
		assert(false)
	
	