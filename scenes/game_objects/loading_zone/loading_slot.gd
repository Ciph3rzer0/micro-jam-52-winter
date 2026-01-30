extends Marker3D

const HOVER_PERIOD := 800.0
const HOVER_RANGE := 1.0/8
const HOVER_HEIGHT := 1.0/3

func _process(_delta):
	# Hover the arrow above the loading zone slot
	var input = Time.get_ticks_msec() + global_position.x * 1300.0 + global_position.z * 1300.0
	var height = sin(input / HOVER_PERIOD) * HOVER_RANGE + HOVER_HEIGHT
	$Indicator.position.y = height
