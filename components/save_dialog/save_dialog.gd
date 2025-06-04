class_name SaveDialog
extends FileDialog


@export var table_view: TableView


func _on_file_selected(path: String) -> void:
	var values: Array[Array] = table_view.get_table_values()
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	if not file:
		push_warning("Fail to save file (error: %s)" % FileAccess.get_open_error())
		return
	
	file.store_string(CSVHelper.to_csv(values))
