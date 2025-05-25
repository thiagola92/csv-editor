## Empty space from the row of columns.
class_name EmptyHeader
extends HBoxContainer


signal cut_requested

signal copy_requested

signal paste_requested

signal add_column_requested

signal add_row_requested

signal clear_requested

@onready var empty_menu: EmptyMenu = $EmptyMenu


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_RIGHT:
		empty_menu.popup(
			Rect2i(
				get_window().position + (get_global_mouse_position() as Vector2i),
				Vector2i(0, 0)
			)
		)


func _on_empty_menu_id_pressed(id: int) -> void:
	match id:
		EmptyMenu.MENU_CUT:
			cut_requested.emit()
		EmptyMenu.MENU_COPY:
			copy_requested.emit()
		EmptyMenu.MENU_PASTE:
			paste_requested.emit()
		EmptyMenu.MENU_ADD_COLUMN:
			add_column_requested.emit()
		EmptyMenu.MENU_ADD_ROW:
			add_row_requested.emit()
		EmptyMenu.MENU_CLEAR:
			clear_requested.emit()
