class_name CellEdit
extends TextEdit


signal window_requested

var cell: Cell

## Text to be registered in UndoRedo when losing focus.
var undo_text: String


func _ready() -> void:
	CellHelper.setup_menu(get_menu())
	CellHelper.setup_text_edit(self)
	
	get_menu().id_pressed.connect(_on_id_pressed)
	
	if cell:
		text = cell.get_text()
		undo_text = text
	
	grab_focus()


func _on_id_pressed(id: int) -> void:
	match id:
		CellHelper.MENU_WINDOW:
			window_requested.emit()


func _on_focus_exited() -> void:
	queue_free()


func _on_tree_exiting() -> void:
	if not cell:
		return
	
	cell.cell_edit = null
	
	if text == undo_text:
		return
	
	UndoHelper.undo_redo.create_action("Change cell")
	UndoHelper.undo_redo.add_do_property(cell.label, "text", text)
	UndoHelper.undo_redo.add_undo_property(cell.label, "text", undo_text)
	UndoHelper.undo_redo.commit_action()


func _on_text_changed() -> void:
	if not cell:
		return
	
	cell.label.text = text
