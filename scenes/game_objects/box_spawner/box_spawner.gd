extends Node3D

@export var scene_to_spawn: PackedScene

func _ready() -> void:
	get_child(0).queue_free()


func spawn() -> void:
	var spawn_position: Vector3 = global_position.round()
	if LevelGrid.is_cell_occupied(spawn_position):
		print("Cannot spawn box: cell is occupied.")
		return
	
	var box_instance: Node3D = scene_to_spawn.instantiate()
	box_instance.position = spawn_position
	owner.add_child(box_instance)


func _on_timer_timeout() -> void:
	print("Spawning box...")
	spawn()
