class_name FileHelper
extends RefCounted


static var current_file: String

static var last_modification: int


static func was_modified() -> bool:
	if not current_file:
		return false
	
	return FileAccess.get_modified_time(current_file) > last_modification
