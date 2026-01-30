extends MovableObject

@export var PUSH_SPEED: float = 5.0

const AUDIO_SLIDE = preload("res://assets/audio/sfx/slide_1.mp3")
const AUDIO_EXCHANGE = preload("res://assets/audio/sfx/jingle-uh-oh.mp3")

var has_fallen: bool = false

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

# A box needs to hold discrete positions and move towards an adjacent tile
func _ready() -> void:
	discrete_position = DiscretePosition.new(self)
	discrete_position.move_speed = PUSH_SPEED
	LevelGrid.add_object_to_grid(self)
	
	discrete_position.move_started.connect(_on_move_started)

func _process(delta: float) -> void:
	# Gravity check - if there's no floor below, fall down
	if not discrete_position.is_moving:
		if discrete_position.current_position.y > 0:
			if LevelGrid.get_object_at_position(discrete_position.current_position + Vector3i.DOWN) == null:
				LevelGrid.try_move_object(self, Vector3i.DOWN)

	discrete_position.tick(delta)
	
	if not has_fallen and global_position.y < -0.3:
		_trigger_fall_effects()

func _trigger_fall_effects() -> void:
	has_fallen = true
	audio_player.stream = AUDIO_EXCHANGE
	audio_player.play()
	
	var label = Label3D.new()
	label.text = "!"
	label.font_size = 96
	label.modulate = Color(1, 0.9, 0.4) # Gold/Yellow
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	# Add to main scene root so it doesn't move with the falling box/parent if parent is special
	# But get_tree().current_scene might be main menu if testing, usually get_parent() is safe if it's the level
	get_parent().add_child(label)
	label.global_position = global_position + Vector3(0, 0.5, 0)
	
	var tween = create_tween()
	tween.tween_property(label, "global_position", label.global_position + Vector3(0, 1.5, 0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(label.queue_free)


func set_convey_speed(conveyer: DiscretePosition) -> void:
	discrete_position.move_speed = conveyer.owner.CONVEY_SPEED
	discrete_position.move_stopped.connect(_on_box_move_stopped, CONNECT_ONE_SHOT)

func _on_box_move_stopped(_previous_position: Vector3i, _current_position: Vector3i) -> void:
	discrete_position.move_speed = PUSH_SPEED

func _on_move_started(_current: Vector3i, _target: Vector3i) -> void:
	audio_player.stream = AUDIO_SLIDE
	audio_player.play()

func collect_box() -> void:
	LevelGrid.remove_object_from_grid(self)
	queue_free()
