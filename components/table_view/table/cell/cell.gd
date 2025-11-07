## Holds one of the values in a CSV line.
##
## The separator in it is invisible, the only purpose it's to make 
## the size match a [ColumnHeader] size.
class_name Cell
extends HBoxContainer


const CellEditScene: PackedScene = preload("../cell_edit/cell_edit.tscn")

const CellWindowScene: PackedScene = preload("../cell_window/cell_window.tscn")

var cell_edit: CellEdit

var cell_window: CellWindow

@onready var label: RichTextLabel = $Label

@onready var column_separator: ColumnSeparator = $ColumnSeparator


func _ready() -> void:
	CellHelper.setup_rich_text_label(label)


func focus_editor() -> void:
	label.hide()
	
	if cell_window:
		return focus_window()
	
	if cell_edit:
		return cell_edit.grab_focus()
	
	cell_edit = CellEditScene.instantiate()
	cell_edit.cell = self
	
	add_child(cell_edit)
	move_child(cell_edit, 0)
	
	cell_edit.window_requested.connect(focus_window)
	cell_edit.tree_exiting.connect(label.show)


func focus_window() -> void:
	label.show()
	
	if cell_edit:
		cell_edit.release_focus()
	
	if cell_window:
		return cell_window.grab_focus()
	
	cell_window = CellWindowScene.instantiate()
	cell_window.cell = self
	
	add_child(cell_window)


func get_text() -> String:
	return label.text


func set_text(text: String) -> void:
	label.text = text
	
	if cell_edit:
		cell_edit.text = label.text
	
	if cell_window:
		cell_window.text_edit.text = label.text


## Set the [member ColumnSeparator.control] for this cell.
## Which should be the [ColumnHeader] of this cell.
func set_control(control: Control) -> void:
	column_separator.control = control


func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_label_gui_mouse_button(event)
	elif event is InputEventKey:
		_on_label_gui_key(event)


func _on_label_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		_on_label_gui_mouse_double_click(event)
	if event.button_index == MOUSE_BUTTON_RIGHT:
		_on_label_gui_mouse_right_click(event)


func _on_label_gui_mouse_double_click(_event: InputEventMouseButton) -> void:
	if cell_window:
		return focus_window()
	
	focus_editor()


func _on_label_gui_mouse_right_click(_event: InputEventMouseButton) -> void:
	focus_editor()
	
	if cell_edit:
		cell_edit.get_menu().popup(
			Rect2i(
				get_window().position + (get_global_mouse_position() as Vector2i),
				Vector2i.ZERO
			)
		)


func _on_label_gui_key(event: InputEventKey) -> void:
	if cell_window:
		return focus_window()
	
	# NOTE: Nothing here will block CellEdit from receiving inputs once it popups.
	# We are just preventing it from popup when it shouldn't.
	if event.is_released() or event.is_echo():
		return
	
	# TODO: If is pressing ctrl/alt/meta/... we may have to trigger shortcuts instead.
	if (event.ctrl_pressed or
		event.alt_pressed or
		event.meta_pressed or
		event.shift_pressed or
		event.keycode == KEY_CTRL or
		event.keycode == KEY_ALT or
		event.keycode == KEY_META or
		event.keycode == KEY_SHIFT):
		return
	
	focus_editor()
