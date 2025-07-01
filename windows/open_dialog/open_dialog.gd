class_name OpenDialog
extends FileDialog


@export var table_view: TableView

@export var bigfile_dialog: BigfileDialog


func _on_file_selected(path: String) -> void:
	if FileAccess.get_size(path) > 1000: # 1KB
		bigfile_dialog.popup_centered()
		
		if not await bigfile_dialog.accepted:
			return
	
	FileHelper.current_file = path
	FileHelper.last_modification = FileAccess.get_modified_time(path)
	
	var lines: Array[Array] = FileHelper.get_content()
	var rows: int = lines.size()
	var columns: int = 0
	
	for l in lines:
		columns = max(columns, l.size())
	
	table_view.recreate_table()
	table_view.set_table_size(columns, rows)
	table_view.set_table_values(lines)
	table_view.refresh_counters()
	
	UndoHelper.undo_redo.clear_history()
