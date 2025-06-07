class_name OverwriteDialog
extends ConfirmationDialog


@export var table_view: TableView


func _ready() -> void:
	get_ok_button().modulate = Color.html("#c64600")


func _on_confirmed() -> void:
	FileHelper.set_content(table_view.get_table_values())
