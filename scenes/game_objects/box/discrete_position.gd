extends Object
class_name DiscretePosition

signal move_started(current_position: Vector3i, target_position: Vector3i)
signal move_stopped(previous_position: Vector3i, current_position: Vector3i)

var owner: Node3D
var move_speed: float = 4.0
var is_move_speed_modified: bool = false

var is_moving = false
var lerp_progress: float = 1.0

var current_position: Vector3i = Vector3i.ZERO
var target_position: Vector3i = Vector3i.ZERO
var last_move_direction: Vector3i = Vector3i.ZERO

func get_move_speed() -> float:
	return move_speed * (GameState.player_speed_modifier if is_move_speed_modified else 1.0)

func _init(_owner: Node3D, _is_move_speed_modified: bool = false)  -> void:
	self.owner = _owner
	self.is_move_speed_modified = _is_move_speed_modified
	self.current_position = _get_discrete_position()
	self.target_position = current_position
	lerp_progress = 1.0


func _get_discrete_position() -> Vector3i:
	var discrete_x = round(owner.global_transform.origin.x)
	var discrete_y = round(owner.global_transform.origin.y)
	var discrete_z = round(owner.global_transform.origin.z)
	return Vector3i(discrete_x, discrete_y, discrete_z)


func move(direction: Vector3i) -> void:
	assert(lerp_progress >= 1.0 and not is_moving, "Cannot start a new move until the previous one is complete.")
	is_moving = true
	move_started.emit(current_position, target_position)

	target_position = current_position + direction
	last_move_direction = direction
	lerp_progress = 0.0


func tick(delta: float) -> void:
	if not is_moving: return

	lerp_progress += move_speed * delta * (GameState.player_speed_modifier if is_move_speed_modified else 1.0)
	lerp_progress = min(lerp_progress, 1.0)
	
	owner.global_position = Vector3(current_position).lerp(Vector3(target_position), lerp_progress)
	
	if lerp_progress >= 1.0:
		is_moving = false
		move_stopped.emit(current_position, target_position)

		current_position = target_position
		
		if LevelGrid.is_tile_ice(target_position):
			LevelGrid.try_move_object(owner, last_move_direction)
	
		owner.global_position = Vector3(current_position)
