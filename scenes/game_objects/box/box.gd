extends CharacterBody3D
class_name MovableObject

@export var PUSH_SPEED: float = 5.0

var discrete_position : DiscretePosition

# A box needs to hold discrete positions and move towards an adjacent tile
func _ready() -> void:
	discrete_position = DiscretePosition.new(self)
	discrete_position.move_speed = PUSH_SPEED
	LevelGrid.add_object_to_grid(self)


func _process(delta: float) -> void:
	# Gravity check - if there's no floor below, fall down
	if not discrete_position.is_moving:
		if discrete_position.current_position.y > 0:
			if LevelGrid.get_object_at_position(discrete_position.current_position - Vector3i.DOWN) == null:
				LevelGrid.try_move_object(self, Vector3i.DOWN)

	discrete_position.tick(delta)


func set_convey_speed(conveyer: DiscretePosition) -> void:
	discrete_position.move_speed = conveyer.owner.CONVEY_SPEED
	discrete_position.move_stopped.connect(_on_box_move_stopped, CONNECT_ONE_SHOT)

func _on_box_move_stopped(_previous_position: Vector3i, _current_position: Vector3i) -> void:
	discrete_position.move_speed = PUSH_SPEED
