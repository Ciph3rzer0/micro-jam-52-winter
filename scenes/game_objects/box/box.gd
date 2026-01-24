extends CharacterBody3D

var current_position: Vector3i = Vector3i.ZERO
var target_position: Vector3i = Vector3i.ZERO
var lerp_progress: float = 1.0

# A box needs to hold discrete positions and move towards an adjacent tile

func _get_discrete_position() -> Vector3i:
		var discrete_x = round(global_transform.origin.x)
		var discrete_y = round(global_transform.origin.y)
		var discrete_z = round(global_transform.origin.z)
		return Vector3i(discrete_x, discrete_y, discrete_z)


func move() -> void:
		current_position = _get_discrete_position()
		target_position = current_position+ Vector3i(1, 0, 0)  # Example: move right by 1 unit
		lerp_progress = 0.0


func _process(delta: float) -> void:
		if Input.is_key_pressed(KEY_M):
				move()

		if lerp_progress < 1.0:
				lerp_progress += delta

		global_position = global_position.lerp(Vector3(target_position), lerp_progress)
		pass
