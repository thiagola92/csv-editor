class_name OpenDialog
extends FileDialog


@export var table_view: TableView


func _on_file_selected(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	
	if not file:
		push_warning("Failed to open file (error: %s)" % FileAccess.get_open_error())
		return
	
	table_view.set_table_values([])
