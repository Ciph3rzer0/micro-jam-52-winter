extends Node3D

@export var scene_to_spawn: PackedScene
@export var spawn_interval: float = 2.0
@export var start_delay: float = 0.0
@export var box_limit: int = 0

var _boxes_spawned: int = 0

func _ready() -> void:
	%Visuals.visible = false
	%Timer.wait_time = start_delay
	%Timer.start()
	print("Box Spawner ready.  Start delay: %f" % start_delay)


func spawn() -> void:
	var spawn_position: Vector3 = global_position.round()
	if LevelGrid.is_cell_occupied(spawn_position):
		print("Cannot spawn box: cell is occupied.")
		return
	
	var box_instance: Node3D = scene_to_spawn.instantiate()
	box_instance.position = spawn_position
	owner.add_child(box_instance)
	_boxes_spawned += 1
	if box_limit > 0 and _boxes_spawned >= box_limit:
		%Timer.stop()


func _on_timer_timeout() -> void:
	%Timer.wait_time = spawn_interval
	%Timer.start()
	print("Spawning box.  Settime: %f" % spawn_interval)
	spawn()
