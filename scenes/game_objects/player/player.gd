extends MovableObject

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		discrete_position.move(Vector3i(0, 0, -1))
	if Input.is_action_pressed("move_left"):
		discrete_position.move(Vector3i(-1, 0, 0))
	if Input.is_action_pressed("move_down"):
		discrete_position.move(Vector3i(0, 0, 1))
	if Input.is_action_pressed("move_right"):
		discrete_position.move(Vector3i(1, 0, 0))

	if discrete_position.is_moving:
		discrete_position.tick(delta)

	# global_position = global_position.lerp(Vector3(discrete_position.target_position), discrete_position.lerp_progress)
