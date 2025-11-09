class_name CellEdit
extends TextEdit


signal window_requested


func _ready() -> void:
	CellHelper.setup_menu(get_menu())
	CellHelper.setup_text_edit(self)
	
	get_menu().id_pressed.connect(_on_id_pressed)
	grab_focus()


func _on_id_pressed(id: int) -> void:
	match id:
		CellHelper.MENU_WINDOW:
			window_requested.emit()


func _on_focus_exited() -> void:
	queue_free()
