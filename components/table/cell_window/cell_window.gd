class_name CellWindow
extends Window


var cell: Cell

@onready var text_edit: TextEdit = $TextEdit


func _ready() -> void:
	CellHelper.setup_menu(text_edit.get_menu(), true)
	
	if cell:
		cell.text_edit.editable = false
		text_edit.text = cell.get_text()
		
		cell.tree_exiting.connect(func(): cell = null)


func _on_close_requested() -> void:
	queue_free()


func _on_tree_exiting() -> void:
	if not cell:
		return
	
	cell.cell_window = null
	cell.text_edit.editable = true
	cell.grab_focus()


func _on_text_edit_text_changed() -> void:
	if not cell:
		return
	
	cell.text_edit.text = text_edit.text
