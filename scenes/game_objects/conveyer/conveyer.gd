extends Node3D

@export var CONVEY_SPEED: float = 1.0

var discrete_position : DiscretePosition

func _ready() -> void:
	discrete_position = DiscretePosition.new(self)

func _process(_delta: float) -> void:
	var box := LevelGrid.get_object_at_position(discrete_position.current_position)

	if box and not box.is_moving and box.owner.is_in_group("box"):
		var convey_direction = Vector3i((global_transform.basis.z).round())
		if LevelGrid.try_move_object(box.owner, convey_direction):
			box.owner.set_convey_speed(self.discrete_position)
