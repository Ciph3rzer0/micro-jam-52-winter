extends MovableObject

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("move_up"):
        move(Vector3i(0, 0, -1))
    if Input.is_action_just_pressed("move_left"):
        move(Vector3i(-1, 0, 0))
    if Input.is_action_just_pressed("move_down"):
        move(Vector3i(0, 0, 1))
    if Input.is_action_just_pressed("move_right"):
        move(Vector3i(1, 0, 0))

    if lerp_progress < 1.0:
        lerp_progress += delta

    global_position = global_position.lerp(Vector3(target_position), lerp_progress)
