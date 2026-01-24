extends Node

var cells : Dictionary[Vector3i, DiscretePosition] = {}
var objects : Dictionary[Node3D, DiscretePosition] = {}

func _ready() -> void:
	pass

func add_object_to_grid(new_object: Node3D) -> void:
	assert(objects.get(new_object) == null, "Node is already registered in the level grid.")
	assert("discrete_position" in new_object, "Node does not have a DiscretePosition component.")
	assert(new_object.discrete_position is DiscretePosition, "Node's discrete_position is not of type DiscretePosition.")

	var position: Vector3i = new_object.discrete_position.current_position

	assert(not cells.has(position), "Cell is already occupied.")

	cells[position] = new_object.discrete_position
	objects[new_object] = new_object.discrete_position


func try_move_object(moving_object: Node3D, relative_motion: Vector3i) -> bool:
	assert(objects.has(moving_object), "Node is not registered in the level grid.")
	assert("discrete_position" in moving_object, "Node does not have a DiscretePosition component.")
	assert(moving_object.discrete_position is DiscretePosition, "Node's discrete_position is not of type DiscretePosition.")
	
	if relative_motion.length() != 1:
		printerr("Relative motion must be to an adjacent cell.")
		assert(false)

	var new_position: Vector3i = moving_object.discrete_position.current_position + relative_motion
	if(cells.has(new_position)):
		print("Cell is already occupied.")
		return false

	# Cell temporarily occupies two positions while moving	
	cells[new_position] = moving_object.discrete_position

	moving_object.discrete_position.move_stopped.connect(
		func(previous_position: Vector3i, _current_position: Vector3i) -> void:
		cells.erase(previous_position)
	, CONNECT_ONE_SHOT
	)

	moving_object.discrete_position.move(relative_motion)
	
	return true
