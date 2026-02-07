extends MovableObject

@export var MAX_MOVE_SPEED: float = 7.0
@export var PUSH_SPEED: float = 5.0

const VEC_UP: Vector3i = Vector3i(0, 0, -1)
const VEC_DOWN: Vector3i = Vector3i(0, 0, 1)
const VEC_LEFT: Vector3i = Vector3i(-1, 0, 0)
const VEC_RIGHT: Vector3i = Vector3i(1, 0, 0)

var tap_move_queue: Array[Vector3i] = []
var move_queue: Array[Vector3i] = []
var is_pushing: bool = false

@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var visuals: Node3D = $character
@onready var audio_steps: AudioStreamPlayer3D = $AudioStreamPlayer3D_Steps
@onready var audio_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D_SFX

const AUDIO_STEP_1 = preload("res://assets/audio/sfx/step_1.mp3")
const AUDIO_STEP_2 = preload("res://assets/audio/sfx/step_2.mp3")
const AUDIO_GRUNT = preload("res://assets/audio/sfx/grunt_1.mp3")
const AUDIO_JINGLE_ACQUIRED = preload("res://assets/audio/sfx/jingle-acquired.mp3")

var step_alternator: bool = false

func _ready() -> void:
	discrete_position = DiscretePosition.new(self, true)
	discrete_position.move_speed = MAX_MOVE_SPEED
	LevelGrid.add_object_to_grid(self)
	discrete_position.move_started.connect(_on_move_started)

func _move_player():
	if Input.is_action_just_pressed("move_up") and tap_move_queue.is_empty():
		if not tap_move_queue.has(VEC_UP):
			tap_move_queue.push_front(VEC_UP)
	
	if Input.is_action_just_pressed("move_down") and tap_move_queue.is_empty():
		if not tap_move_queue.has(VEC_DOWN):
			tap_move_queue.push_front(VEC_DOWN)

	if Input.is_action_just_pressed("move_left") and tap_move_queue.is_empty():
		if not tap_move_queue.has(VEC_LEFT):
			tap_move_queue.push_front(VEC_LEFT)

	if Input.is_action_just_pressed("move_right") and tap_move_queue.is_empty():
		if not tap_move_queue.has(VEC_RIGHT):
			tap_move_queue.push_front(VEC_RIGHT)

	if not discrete_position.is_moving and not tap_move_queue.is_empty():
		var dir = tap_move_queue.pop_front()
		_update_rotation(dir)
		if not discrete_position.is_moving:
			LevelGrid.try_move_player(self, dir)
		return
	
	_move_player_hold()

func _move_player_hold():
	# Hold Queue
	var queued_move_up = move_queue.find(VEC_UP)
	var queued_move_left = move_queue.find(VEC_LEFT)
	var queued_move_down = move_queue.find(VEC_DOWN)
	var queued_move_right = move_queue.find(VEC_RIGHT)

	if Input.is_action_pressed("move_up"):
		if queued_move_up < 0:
			move_queue.push_front(VEC_UP)
	else:
		if queued_move_up >= 0:
			move_queue.erase(VEC_UP)
	
	if Input.is_action_pressed("move_down"):
		if queued_move_down < 0:
			move_queue.push_front(VEC_DOWN)
	else:
		if queued_move_down >= 0:
			move_queue.erase(VEC_DOWN)
	

	if Input.is_action_pressed("move_left"):
		if queued_move_left < 0:
			move_queue.push_front(VEC_LEFT)
	else:
		if queued_move_left >= 0:
			move_queue.erase(VEC_LEFT)


	if Input.is_action_pressed("move_right"):
		if queued_move_right < 0:
			move_queue.push_front(VEC_RIGHT)
	else:
		if queued_move_right >= 0:
			move_queue.erase(VEC_RIGHT)

	if not discrete_position.is_moving and not move_queue.is_empty():
		_update_rotation(move_queue.front())
		if not discrete_position.is_moving:
			LevelGrid.try_move_player(self, move_queue.front())

func _process(delta: float) -> void:
	_move_player()

	discrete_position.tick(delta)
	_update_animation_state()

@export var step_interval: int = 2
@export var step_delay: float = 0.0

var move_count: int = 0

func _on_move_started(_current: Vector3i, _target: Vector3i) -> void:
	move_count += 1
	if move_count % step_interval != 0:
		return

	if step_delay > 0:
		await get_tree().create_timer(step_delay).timeout

	if step_alternator:
		audio_steps.stream = AUDIO_STEP_1
	else:
		audio_steps.stream = AUDIO_STEP_2
	audio_steps.play()
	step_alternator = !step_alternator

func set_push_speed(box: DiscretePosition) -> void:
	is_pushing = true
	discrete_position.move_speed = PUSH_SPEED
	box.move_speed = discrete_position.get_move_speed()
	box.move_stopped.connect(_on_box_move_stopped, CONNECT_ONE_SHOT)
	
	audio_sfx.stream = AUDIO_GRUNT
	audio_sfx.volume_db = -10.0
	audio_sfx.play()

func _on_box_move_stopped(_previous_position: Vector3i, _current_position: Vector3i) -> void:
	is_pushing = false
	discrete_position.move_speed = MAX_MOVE_SPEED

func _update_rotation(direction: Vector3i) -> void:
	var target_rotation_y = visuals.rotation_degrees.y
	match direction:
		VEC_UP:
			target_rotation_y = 180.0
		VEC_DOWN:
			target_rotation_y = 0.0
		VEC_LEFT:
			target_rotation_y = -90.0
		VEC_RIGHT:
			target_rotation_y = 90.0
	
	visuals.rotation_degrees.y = target_rotation_y

func _update_animation_state() -> void:
	if Input.is_key_pressed(KEY_1):
		_play_animation("victory_001")
		if audio_sfx.stream != AUDIO_JINGLE_ACQUIRED or not audio_sfx.playing:
			audio_sfx.stream = AUDIO_JINGLE_ACQUIRED
			audio_sfx.play()
		return

	if Input.is_key_pressed(KEY_2):
		_play_animation("shove")
		return

	if discrete_position.is_moving or not move_queue.is_empty():
		if is_pushing:
			_play_animation("shove-loop")
		else:
			_play_animation("walk")
	else:
		if animation_player.current_animation != "victory_001":
			_play_animation("idle")

func _play_animation(anim_name: String) -> void:
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)
