extends Node3D

var discrete_position : DiscretePosition

# A box needs to hold discrete positions and move towards an adjacent tile
func _ready() -> void:
	discrete_position = DiscretePosition.new(self)
	LevelGrid.add_object_to_grid(self)
	get_child(0).queue_free()
