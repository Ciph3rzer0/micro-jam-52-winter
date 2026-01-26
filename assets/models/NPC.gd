extends MovableObject

@onready var animation_player: AnimationPlayer = $character2/AnimationPlayer
@onready var audio_sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D_SFX
@onready var timer = $Timer

var animation_count : int = 0
const AUDIO_JINGLE_ACQUIRED = preload("res://assets/audio/sfx/jingle-acquired.mp3")

func _process(delta: float) -> void:
	_update_animation_state()

func _update_animation_state() -> void:
	_play_animation("foreman-idle-2")

func _play_animation(anim_name: String) -> void:
	if animation_player.current_animation != anim_name:
		animation_count += 1
		if animation_count % 10 == 0:
			animation_player.play("foreman-idle-2")
		animation_player.play(anim_name)

#func make_noise() -> void:
	#audio_sfx.stream = AUDIO_JINGLE_ACQUIRED
	#audio_sfx.volume_db = -10.0
	#audio_sfx.play()
