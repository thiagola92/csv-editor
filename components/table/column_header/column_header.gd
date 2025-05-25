## Show the column index and provide a menu for the user interact with the column.
class_name ColumnHeader
extends HBoxContainer


signal cut_requested(index: int)

signal copy_requested(index: int)

signal paste_requested(index: int)

signal add_before_requested(index: int)

signal add_after_requested(index: int)

signal clear_requested(index: int)

signal delete_requested(index: int)

@export var _label: Label

@onready var _column_menu: ColumnMenu = $ColumnMenu


func set_text(text: String) -> void:
	_label.text = text


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_RIGHT:
		_column_menu.popup(
			Rect2i(
				get_window().position + (get_global_mouse_position() as Vector2i),
				Vector2i(0, 0)
			)
		)


func _on_column_menu_id_pressed(id: int) -> void:
	match id:
		ColumnMenu.MENU_CUT:
			cut_requested.emit(get_index())
		ColumnMenu.MENU_COPY:
			copy_requested.emit(get_index())
		ColumnMenu.MENU_PASTE:
			paste_requested.emit(get_index())
		ColumnMenu.MENU_ADD_BEFORE:
			add_before_requested.emit(get_index())
		ColumnMenu.MENU_ADD_AFTER:
			add_after_requested.emit(get_index())
		ColumnMenu.MENU_CLEAR:
			clear_requested.emit(get_index())
		ColumnMenu.MENU_DELETE:
			delete_requested.emit(get_index())
