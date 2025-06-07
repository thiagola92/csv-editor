class_name FileHelper
extends RefCounted


static var current_file: String

static var last_modification: int


static func get_content() -> Array[Array]:
	var content: String = FileAccess.get_file_as_string(current_file)
	var error: Error = FileAccess.get_open_error()
	
	if content.is_empty() and error:
		push_warning("Failed to open file (error: %s)" % error)
		return []
	
	return CSVHelper.from_text(content)


static func set_content(values: Array[Array]) -> void:
	if not current_file:
		return
	
	var content: String = CSVHelper.to_csv(values)
	var file := FileAccess.open(current_file, FileAccess.WRITE)
	
	if not file:
		push_warning("Failed to save file (error %s)" % FileAccess.get_open_error())
		return
	
	file.store_string(content)
	last_modification = FileAccess.get_modified_time(current_file)


static func was_modified() -> bool:
	if not current_file:
		return false
	
	return FileAccess.get_modified_time(current_file) > last_modification
