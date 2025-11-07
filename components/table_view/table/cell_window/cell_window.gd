class_name CellWindow
extends Window


var cell: Cell

## Text to be registered in UndoRedo when closing window.
var undo_text: String

@onready var text_edit: TextEdit = $TextEdit


func _ready() -> void:
	CellHelper.setup_menu(text_edit.get_menu(), true)
	
	if cell:
		text_edit.text = cell.get_text()
		undo_text = text_edit.text
	
	text_edit.grab_focus()


func _on_close_requested() -> void:
	queue_free()


func _on_tree_exiting() -> void:
	if not cell:
		return
	
	cell.cell_window = null
	
	if text_edit.text == undo_text:
		return
	
	UndoHelper.undo_redo.create_action("Change cell through window")
	UndoHelper.undo_redo.add_do_property(cell.label, "text", text_edit.text)
	UndoHelper.undo_redo.add_undo_property(cell.label, "text", undo_text)
	UndoHelper.undo_redo.commit_action(false)


func _on_text_edit_text_changed() -> void:
	if not cell:
		return
	
	cell.label.text = text_edit.text
