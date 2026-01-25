extends Node3D

var discrete_position : DiscretePosition

func _ready() -> void:
	discrete_position = DiscretePosition.new(self)
	LevelGrid.add_ice_tile_to_grid(self)
