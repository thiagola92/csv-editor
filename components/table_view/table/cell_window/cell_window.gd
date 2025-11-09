class_name CellWindow
extends Window


signal text_changed

@export var text_edit: TextEdit


func _ready() -> void:
	CellHelper.setup_menu(text_edit.get_menu(), true)
	text_edit.grab_focus()


func _on_close_requested() -> void:
	queue_free()


func _on_text_edit_text_changed() -> void:
	text_changed.emit()
