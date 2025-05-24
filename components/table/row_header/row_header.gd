## Show the row index and provide a menu for the user interact with the row.
class_name RowHeader
extends HBoxContainer


signal add_above_requested

signal add_below_requested

@onready var _label: Label = %Label

@onready var _row_menu: RowMenu = $RowMenu


func set_text(text: String) -> void:
	_label.text = text


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_RIGHT:
		_row_menu.popup(
			Rect2i(
				get_window().position + (get_global_mouse_position() as Vector2i),
				Vector2i(0, 0)
			)
		)


func _on_row_menu_id_pressed(id: int) -> void:
	match id:
		RowMenu.MENU_CUT:
			pass
		RowMenu.MENU_COPY:
			pass
		RowMenu.MENU_PASTE:
			pass
		RowMenu.MENU_ADD_ABOVE:
			add_above_requested.emit()
		RowMenu.MENU_ADD_BELOW:
			add_below_requested.emit()
		RowMenu.MENU_CLEAR:
			pass
