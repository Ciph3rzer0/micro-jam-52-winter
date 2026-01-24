extends MovableObject

func _ready() -> void:
	discrete_position = DiscretePosition.new(self)
	LevelGrid.add_object_to_grid(self)

func _process(delta: float) -> void:
	if not discrete_position.is_moving:
		if Input.is_action_pressed("move_up"):
			LevelGrid.try_move_object(self, Vector3i(0, 0, -1))
		elif Input.is_action_pressed("move_left"):
			LevelGrid.try_move_object(self, Vector3i(-1, 0, 0))
		elif Input.is_action_pressed("move_down"):
			LevelGrid.try_move_object(self, Vector3i(0, 0, 1))
		elif Input.is_action_pressed("move_right"):
			LevelGrid.try_move_object(self, Vector3i(1, 0, 0))

	discrete_position.tick(delta)
