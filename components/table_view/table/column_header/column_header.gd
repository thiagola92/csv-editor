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

signal fit_requested(index: int)

signal move_requested(from: int, to: int)

@export var label: Label

@onready var column_menu: ColumnMenu = $ColumnMenu


func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cut"):
		cut_requested.emit(get_index())
	elif event.is_action_pressed("ui_copy"):
		copy_requested.emit(get_index())
	elif event.is_action_pressed("ui_paste"):
		paste_requested.emit(get_index())


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is ColumnHeader


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is ColumnHeader:
		move_requested.emit(data.get_index(), get_index())


func _get_drag_data(_at_position: Vector2) -> Variant:
	return self


func update_label(index: int) -> void:
	label.text = str(index)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_RIGHT:
		column_menu.popup(
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
		ColumnMenu.MENU_FIT:
			fit_requested.emit(get_index())
