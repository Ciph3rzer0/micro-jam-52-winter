extends MovableObject

@export var MAX_MOVE_SPEED: float = 7.0

const VEC_UP: Vector3i = Vector3i(0, 0, -1)
const VEC_DOWN: Vector3i = Vector3i(0, 0, 1)
const VEC_LEFT: Vector3i = Vector3i(-1, 0, 0)
const VEC_RIGHT: Vector3i = Vector3i(1, 0, 0)

var move_queue: Array[Vector3i] = []

func _ready() -> void:
	discrete_position = DiscretePosition.new(self)
	discrete_position.move_speed = MAX_MOVE_SPEED
	LevelGrid.add_object_to_grid(self)

func _process(delta: float) -> void:
	var queued_move_up = move_queue.find(VEC_UP)
	var queued_move_left = move_queue.find(VEC_LEFT)
	var queued_move_down = move_queue.find(VEC_DOWN)
	var queued_move_right = move_queue.find(VEC_RIGHT)

	if Input.is_action_pressed("move_up"):
		if queued_move_up < 0:
			move_queue.push_front(VEC_UP)
	else:
		if queued_move_up >= 0:
			move_queue.erase(VEC_UP)
	
	if Input.is_action_pressed("move_down"):
		if queued_move_down < 0:
			move_queue.push_front(VEC_DOWN)
	else:
		if queued_move_down >= 0:
			move_queue.erase(VEC_DOWN)
	

	if Input.is_action_pressed("move_left"):
		if queued_move_left < 0:
			move_queue.push_front(VEC_LEFT)
	else:
		if queued_move_left >= 0:
			move_queue.erase(VEC_LEFT)


	if Input.is_action_pressed("move_right"):
		if queued_move_right < 0:
			move_queue.push_front(VEC_RIGHT)
	else:
		if queued_move_right >= 0:
			move_queue.erase(VEC_RIGHT)

	if not move_queue.is_empty():
		if not discrete_position.is_moving:
			LevelGrid.try_move_player(self, move_queue.front())

	discrete_position.tick(delta)

func set_push_speed(box: DiscretePosition) -> void:
	discrete_position.move_speed = box.move_speed
	box.move_stopped.connect(_on_box_move_stopped, CONNECT_ONE_SHOT)

func _on_box_move_stopped(_previous_position: Vector3i, _current_position: Vector3i) -> void:
	discrete_position.move_speed = MAX_MOVE_SPEED
