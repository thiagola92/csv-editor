class_name OpenDialog
extends FileDialog


@export var table_view: TableView


func _on_file_selected(path: String) -> void:
	FileHelper.current_file = path
	FileHelper.last_modification = FileAccess.get_modified_time(path)
	
	var lines: Array[Array] = FileHelper.get_content()
	var rows: int = lines.size()
	var columns: int = 0
	
	for l in lines:
		columns = max(columns, l.size())
	
	table_view.recreate_table()
	table_view.set_table_size(rows, columns)
	table_view.set_table_values(lines)
	table_view.refresh_counters()
	
	UndoHelper.undo_redo.clear_history()
