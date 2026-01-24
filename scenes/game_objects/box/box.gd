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
	if not discrete_position.is_moving:
		if Input.is_key_pressed(KEY_M):
			LevelGrid.try_move_object(self, Vector3i(1, 0, 0))

	discrete_position.tick(delta)
