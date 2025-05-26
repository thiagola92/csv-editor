class_name CellWindow
extends Window


var cell: Cell

@onready var text_edit: TextEdit = $TextEdit


func _ready() -> void:
	CellMenu.setup(text_edit.get_menu(), true)
	
	if cell:
		cell.editable = false
		text_edit.text = cell.text
		
		cell.tree_exiting.connect(func(): cell = null)


func clear() -> void:
	text_edit.clear()


func _on_close_requested() -> void:
	queue_free()


func _on_tree_exiting() -> void:
	if not cell:
		return
	
	cell.cell_window = null
	cell.editable = true
	cell.grab_focus()


func _on_text_edit_text_changed() -> void:
	if not cell:
		return
	
	cell.text = text_edit.text
