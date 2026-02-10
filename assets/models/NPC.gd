extends MovableObject

@onready var animation_player: AnimationPlayer = $character2/AnimationPlayer
@onready var audio_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D_SFX
@onready var timer = $Timer

var animation_count: int = 0
var victory_mode: bool = false
const AUDIO_JINGLE_ACQUIRED = preload("res://assets/audio/sfx/jingle-acquired.mp3")

func _ready() -> void:
	add_to_group("foreman")

func _process(_delta: float) -> void:
	_update_animation_state()

func _update_animation_state() -> void:
	if victory_mode:
		_play_animation("victory_001")
	else:
		_play_animation("foreman-idle-2")

func _play_animation(anim_name: String) -> void:
	if animation_player.current_animation != anim_name:
		animation_count += 1
		if animation_count % 10 == 0:
			if not victory_mode:
				animation_player.play("foreman-idle-2")
		animation_player.play(anim_name)

func play_victory_animation() -> void:
	victory_mode = true
