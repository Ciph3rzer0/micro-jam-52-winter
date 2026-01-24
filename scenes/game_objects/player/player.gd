extends MovableObject

@export var MAX_MOVE_SPEED: float = 7.0

func _ready() -> void:
	discrete_position = DiscretePosition.new(self)
	discrete_position.move_speed = MAX_MOVE_SPEED
	LevelGrid.add_object_to_grid(self)

func _process(delta: float) -> void:
	if not discrete_position.is_moving:
		if Input.is_action_pressed("move_up"):
			LevelGrid.try_move_player(self, Vector3i(0, 0, -1))
		elif Input.is_action_pressed("move_left"):
			LevelGrid.try_move_player(self, Vector3i(-1, 0, 0))
		elif Input.is_action_pressed("move_down"):
			LevelGrid.try_move_player(self, Vector3i(0, 0, 1))
		elif Input.is_action_pressed("move_right"):
			LevelGrid.try_move_player(self, Vector3i(1, 0, 0))

	discrete_position.tick(delta)

func set_push_speed(box: DiscretePosition) -> void:
	discrete_position.move_speed = box.move_speed
	box.move_stopped.connect(_on_box_move_stopped, CONNECT_ONE_SHOT)

func _on_box_move_stopped(_previous_position: Vector3i, _current_position: Vector3i) -> void:
	discrete_position.move_speed = MAX_MOVE_SPEED
