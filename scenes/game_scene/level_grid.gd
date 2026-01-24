extends Node

var cells : Dictionary[Vector3i, DiscretePosition] = {}
var objects : Dictionary[Node3D, DiscretePosition] = {}

func _ready() -> void:
	pass


func get_object_at_position(position: Vector3i) -> DiscretePosition:
	return cells.get(position)


func add_object_to_grid(new_object: Node3D) -> void:
	assert(objects.get(new_object) == null, "Node is already registered in the level grid.")
	assert("discrete_position" in new_object, "Node does not have a DiscretePosition component.")
	assert(new_object.discrete_position is DiscretePosition, "Node's discrete_position is not of type DiscretePosition.")

	var position: Vector3i = new_object.discrete_position.current_position

	assert(not cells.has(position), "Cell is already occupied.")

	cells[position] = new_object.discrete_position
	objects[new_object] = new_object.discrete_position

# A player can push boxes.  So we move the box ahead one cell and the player takes up two cells temporarily.
func try_move_player(moving_object: Node3D, relative_motion: Vector3i) -> bool:
	assert_grid_object_is_valid(moving_object)
	assert(relative_motion.length() == 1, "Relative motion must be to an adjacent cell.")

	var new_position: Vector3i = moving_object.discrete_position.current_position + relative_motion

	# Check if there is no object at target position or that it is push-able
	var object_at_new_position: DiscretePosition = cells.get(new_position)

	if(object_at_new_position != null):
		# Try to push the object
		var push_successful: bool = try_move_object(object_at_new_position.owner, relative_motion, true)
		if(not push_successful):
			print("Cannot move player because object cannot be pushed.")
			return false
	
	if(cells.has(new_position)):
		print("Cell is already occupied.")
		return false

	return try_move_object(moving_object, relative_motion)


func try_move_object(moving_object: Node3D, relative_motion: Vector3i, move_instantly = false) -> bool:
	assert_grid_object_is_valid(moving_object)
	assert(relative_motion.length() == 1, "Relative motion must be to an adjacent cell.")

	var new_position: Vector3i = moving_object.discrete_position.current_position + relative_motion
	if(cells.has(new_position)):
		print("Cell is already occupied.")
		return false

	# Cell temporarily occupies two positions while moving	
	cells[new_position] = moving_object.discrete_position

	if move_instantly:
		cells.erase(moving_object.discrete_position.current_position)
	else:
		moving_object.discrete_position.move_stopped.connect(
			func(previous_position: Vector3i, _current_position: Vector3i) -> void:
			cells.erase(previous_position)
		, CONNECT_ONE_SHOT
		)

	moving_object.discrete_position.move(relative_motion)
	
	return true

func assert_grid_object_is_valid(test_object: Node3D) -> void:
	assert(objects.has(test_object), "Node is not registered in the level grid.")
	assert("discrete_position" in test_object, "Node does not have a DiscretePosition component.")
	assert(test_object.discrete_position is DiscretePosition, "Node's discrete_position is not of type DiscretePosition.")
