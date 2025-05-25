## Show the row index and provide a menu for the user interact with the row.
class_name RowHeader
extends HBoxContainer


signal cut_requested

signal copy_requested

signal paste_requested

signal add_above_requested

signal add_below_requested

signal clear_requested

signal delete_requested

@onready var label: Label = %Label

@onready var row_menu: RowMenu = $RowMenu


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_RIGHT:
		row_menu.popup(
			Rect2i(
				get_window().position + (get_global_mouse_position() as Vector2i),
				Vector2i(0, 0)
			)
		)


func _on_row_menu_id_pressed(id: int) -> void:
	match id:
		RowMenu.MENU_CUT:
			cut_requested.emit()
		RowMenu.MENU_COPY:
			copy_requested.emit()
		RowMenu.MENU_PASTE:
			paste_requested.emit()
		RowMenu.MENU_ADD_ABOVE:
			add_above_requested.emit()
		RowMenu.MENU_ADD_BELOW:
			add_below_requested.emit()
		RowMenu.MENU_CLEAR:
			clear_requested.emit()
		RowMenu.MENU_DELETE:
			delete_requested.emit()
