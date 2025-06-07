class_name SaveDialog
extends FileDialog


@export var table_view: TableView


func _on_file_selected(path: String) -> void:
	FileHelper.current_file = path
	FileHelper.set_content(table_view.get_table_values())
