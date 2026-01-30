@tool
extends Label
## Displays the version from the VERSION file at the project root.

const NO_VERSION_STRING : String = "0.0.0"
const VERSION_FILE_PATH : String = "res://VERSION"

## Prefixes the version when displaying to the user.
@export var version_prefix : String = "v"

func update_version_label() -> void:
	var config_version : String = NO_VERSION_STRING
	
	if FileAccess.file_exists(VERSION_FILE_PATH):
		var file = FileAccess.open(VERSION_FILE_PATH, FileAccess.READ)
		if file:
			config_version = file.get_as_text().strip_edges()
			file.close()
	
	if config_version.is_empty():
		config_version = NO_VERSION_STRING
	text = version_prefix + config_version

func _ready() -> void:
	update_version_label()
