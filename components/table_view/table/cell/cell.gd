## Holds one of the values in a CSV line.
##
## The separator in it is invisible, the only purpose it's to make 
## the size match a [ColumnHeader] size.
class_name Cell
extends HBoxContainer


const CellWindowScene: PackedScene = preload("../cell_window/cell_window.tscn")

var cell_window: CellWindow

## Text to be registered in UndoRedo when leaving focus.
var undo_text: String

@onready var text_edit: TextEdit = $TextEdit

@onready var column_separator: ColumnSeparator = $ColumnSeparator


func _ready() -> void:
	CellHelper.setup_menu(text_edit.get_menu())
	CellHelper.setup_text_edit(text_edit)
	
	text_edit.get_menu().id_pressed.connect(_on_id_pressed)


func clear() -> void:
	# Release focus to avoid trigerring UndoRedo.
	text_edit.release_focus()
	text_edit.clear()
	
	if cell_window:
		cell_window.text_edit.text = text_edit.text


func focus_window() -> void:
	if cell_window:
		return cell_window.grab_focus()
	
	cell_window = CellWindowScene.instantiate()
	cell_window.cell = self
	
	add_child(cell_window)


func get_text() -> String:
	return text_edit.text


func reset_scroll() -> void:
	text_edit.get_v_scroll_bar().value = 0
	text_edit.get_h_scroll_bar().value = 0


func set_text(text: String) -> void:
	text_edit.text = text
	
	if cell_window:
		cell_window.text_edit.text = text_edit.text


func set_control(control: Control) -> void:
	column_separator.control = control


func _on_id_pressed(id: int) -> void:
	match id:
		CellHelper.MENU_WINDOW:
			focus_window()


func _on_text_edit_focus_exited() -> void:
	reset_scroll()
	
	text_edit.editable = false
	text_edit.shortcut_keys_enabled = false
	
	if text_edit.text == undo_text:
		return
	
	if cell_window:
		return
	
	UndoHelper.undo_redo.create_action("Change cell")
	UndoHelper.undo_redo.add_do_property(text_edit, "text", text_edit.text)
	UndoHelper.undo_redo.add_undo_property(text_edit, "text", undo_text)
	UndoHelper.undo_redo.commit_action(false)


func _on_text_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_text_edit_gui_mouse_button(event)
	elif event is InputEventKey:
		_on_text_edit_gui_key(event)


func _on_text_edit_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		_on_text_edit_gui_mouse_double_click(event)


func _on_text_edit_gui_mouse_double_click(_event: InputEventMouseButton) -> void:
	if cell_window:
		cell_window.grab_focus()
		return
	
	text_edit.editable = true
	text_edit.caret_blink = true
	text_edit.shortcut_keys_enabled = true
	undo_text = text_edit.text


func _on_text_edit_gui_key(_event: InputEventKey) -> void:
	if text_edit.editable:
		return
	
