extends Marker3D
class_name LoadingSlot

const COLOR_ACTIVE: Color = Color(0, 1, 0) # Green
const COLOR_INACTIVE: Color = Color(1, 1, 1) # White

const HOVER_PERIOD := 800.0
const HOVER_RANGE := 1.0/8
const HOVER_HEIGHT := 1.0/3

@onready var owning_loading_zone: LoadingZone = get_parent().get_parent()
@onready var slot_mesh: MeshInstance3D = $SlotMesh as MeshInstance3D
@onready var discrete_position: DiscretePosition = DiscretePosition.new(self)
var is_filled: bool = false


func _ready() -> void:
	assert(slot_mesh != null, "LoadingSlot: Slot mesh not found!")
	slot_mesh.material_override = StandardMaterial3D.new()


func _process(_delta):
	# Hover the arrow above the loading zone slot
	var input = Time.get_ticks_msec() + global_position.x * 1300.0 + global_position.z * 1300.0
	var height = sin(input / HOVER_PERIOD) * HOVER_RANGE + HOVER_HEIGHT
	$Indicator.position.y = height
	_check_for_box()

	if owning_loading_zone.fully_loaded:
		slot_mesh.material_override.albedo_color \
			= LoadingSlot.COLOR_ACTIVE.lerp(LoadingSlot.COLOR_INACTIVE, \
			(sin(Time.get_ticks_msec() / 100.0) * 0.5 + 0.5))


func _check_for_box() -> void:
	var object := LevelGrid.get_object_at_position(discrete_position.current_position)
	if object != null:
		# 	print("Name: %s at loading slot %s" % [object.owner.name, slot.current_position])
		if not object.is_moving and object.owner.is_in_group("box"):
			_set_filled_state(true)
		else:
			_set_filled_state(false)
	else:
		_set_filled_state(false)


func _set_filled_state(filled: bool) -> void:
	is_filled = filled
	if filled:
		slot_mesh.material_override.albedo_color = COLOR_ACTIVE
	else:
		slot_mesh.material_override.albedo_color = COLOR_INACTIVE
