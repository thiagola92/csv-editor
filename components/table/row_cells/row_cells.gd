## Represents a row of cells.
##
## [codeblock]
## | row 0 | cell 0 | cell 1 | cell 2 | ... | cell X |
## | ------------------ separator ------------------ |
## [/codeblock]
## [br]
## - header: [RowHeader][br]
## - cell: [Cell][br]
## - separator: [RowSeparator][br]
class_name RowCells
extends VBoxContainer


const CellScene: PackedScene = preload("../cell/cell.tscn")

@export var table: Table

@onready var row_header: RowHeader = %RowHeader

@onready var cells: HBoxContainer = %Cells


###############################################################
# RowHeader methods
###############################################################


func set_header_width(x: float) -> void:
	row_header.custom_minimum_size.x = x


func update_header_label(index: int) -> void:
	row_header.update_label(index)


###############################################################
# Cell methods (CORE)
# add_xxx, get_xxx, move_xxx, remove_xxx and their plural version.
###############################################################


func add_cell(index: int) -> void:
	var cell: Cell = CellScene.instantiate()
	
	cells.add_child(cell)
	cells.move_child(cell, index)


func add_cells(index: int, quantity: int) -> void:
	for i in quantity:
		add_cell(index)


func get_cell(index: int) -> Cell:
	return cells.get_child(index) as Cell


func get_cells() -> Array[Cell]:
	var array: Array[Cell]
	array.assign(cells.get_children())
	return array


func move_cell(from: int, to: int) -> void:
	cells.move_child(get_cell(from), to)


func remove_cell(index: int) -> void:
	get_cell(index).queue_free()


###############################################################
# Cell methods (UTILITY)
###############################################################


func get_cells_values() -> Array[String]:
	var texts: Array[String] = []
	
	for c in get_cells():
		texts.append(c.get_text())
	
	return texts


func get_cells_count() -> int:
	return cells.get_child_count()


func set_cell_width(index: int, x: float) -> void:
	get_cell(index).custom_minimum_size.x = x


func set_cells_values(values: Array[String]) -> void:
	for i in min(values.size(), get_cells_count()):
		get_cell(i).set_text(values[i])


func clear_cell(index: int) -> void:
	get_cell(index).clear()


func clear_cells() -> void:
	for c in get_cells():
		c.clear()


###############################################################
# RowHeader signals
###############################################################


func _on_row_header_add_above_requested() -> void:
	if not table:
		return
	
	var index: int = get_index()
	
	table.add_row(index)
	table.update_rows_label(index)
	
	var new_row: RowCells = table.get_row(index)
	
	UndoHelper.undo_redo.create_action("Add row above")
	UndoHelper.undo_redo.add_do_method(table.add_row.bind(index, new_row))
	UndoHelper.undo_redo.add_do_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.add_do_reference(new_row)
	UndoHelper.undo_redo.add_undo_method(table.rows.remove_child.bind(new_row))
	UndoHelper.undo_redo.add_undo_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.commit_action(false)


func _on_row_header_add_below_requested() -> void:
	if not table:
		return
	
	var index: int = get_index() + 1
	
	table.add_row(index)
	table.update_rows_label(index)
	
	var new_row: RowCells = table.get_row(index)
	
	UndoHelper.undo_redo.create_action("Add row below")
	UndoHelper.undo_redo.add_do_method(table.add_row.bind(index, new_row))
	UndoHelper.undo_redo.add_do_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.add_do_reference(new_row)
	UndoHelper.undo_redo.add_undo_method(table.rows.remove_child.bind(new_row))
	UndoHelper.undo_redo.add_undo_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.commit_action(false)


func _on_row_header_clear_requested() -> void:
	var values: Array[String] = get_cells_values()
	
	UndoHelper.undo_redo.create_action("Clear row")
	UndoHelper.undo_redo.add_do_method(clear_cells)
	UndoHelper.undo_redo.add_undo_method(set_cells_values.bind(values))
	UndoHelper.undo_redo.commit_action()


func _on_row_header_copy_requested() -> void:
	var values: Array[String] = get_cells_values()
	var text: String = CSVHelper.to_csv([values], true)
	
	DisplayServer.clipboard_set(text)


func _on_row_header_cut_requested() -> void:
	var values: Array[String] = get_cells_values()
	var text: String = CSVHelper.to_csv([values], true)
	
	DisplayServer.clipboard_set(text)
	
	UndoHelper.undo_redo.create_action("Cut row")
	UndoHelper.undo_redo.add_do_method(clear_cells)
	UndoHelper.undo_redo.add_undo_method(set_cells_values.bind(values))
	UndoHelper.undo_redo.commit_action()


func _on_row_header_delete_requested() -> void:
	if not table:
		return queue_free()
	
	var index: int = get_index()
	
	UndoHelper.undo_redo.create_action("Delete row")
	UndoHelper.undo_redo.add_do_method(table.rows.remove_child.bind(self))
	UndoHelper.undo_redo.add_do_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.add_do_reference(self)
	UndoHelper.undo_redo.add_undo_method(table.rows.add_child.bind(self))
	UndoHelper.undo_redo.add_undo_method(table.rows.move_child.bind(self, index))
	UndoHelper.undo_redo.add_undo_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.commit_action()


func _on_row_header_paste_requested() -> void:
	var values: Array[String] = get_cells_values()
	var text: String = DisplayServer.clipboard_get()
	var lines: Array[Array] = CSVHelper.from_text(text, true)
	var new_values: Array[String]
	
	if lines.is_empty():
		return
	
	new_values.assign(lines[0])
	
	UndoHelper.undo_redo.create_action("Paste row")
	UndoHelper.undo_redo.add_do_method(set_cells_values.bind(new_values))
	UndoHelper.undo_redo.add_undo_method(set_cells_values.bind(values))
	UndoHelper.undo_redo.commit_action()


func _on_row_header_move_requested(from: RowHeader) -> void:
	if not table:
		return
	
	var parent: Node = from.get_parent()
	
	while parent is not RowCells:
		parent = parent.get_parent()
		
		if parent == null:
			return
	
	var from_index: int = parent.get_index()
	var to_index: int = get_index()
	var min_index: int = min(from_index, to_index)
	
	UndoHelper.undo_redo.create_action("Move row")
	UndoHelper.undo_redo.add_do_method(table.move_row.bind(from_index, to_index))
	UndoHelper.undo_redo.add_do_method(table.update_rows_label.bind(min_index))
	UndoHelper.undo_redo.add_undo_method(table.move_row.bind(to_index, from_index))
	UndoHelper.undo_redo.add_undo_method(table.update_rows_label.bind(min_index))
	UndoHelper.undo_redo.commit_action()


func _on_row_header_minimum_size_changed() -> void:
	if not table:
		return
	
	var width: float = row_header.custom_minimum_size.x # NOTE: Not the custom_minimum_size.
	
	table.row_columns.set_header_width(width)
