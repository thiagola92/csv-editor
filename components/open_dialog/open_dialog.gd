class_name OpenDialog
extends FileDialog


@export var table_view: TableView


func _on_file_selected(path: String) -> void:
	print(path)
