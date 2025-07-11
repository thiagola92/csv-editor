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

@onready var row: HBoxContainer = $Row

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


func add_cell(index: int, cell: Cell = null) -> void:
	if not cell:
		cell = CellScene.instantiate()
	
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
	cells.remove_child(get_cell(index))


###############################################################
# Cell methods (UTILITY)
###############################################################


func get_cell_value(index: int) -> String:
	return get_cell(index).get_text()


## Get the cells that will be target if quantity change to [param]quantity[/parma].[br]
## [br]
## [b]Note[/b]: Helps with undoing & redoing [method set_cells_quantity].
func get_cells_target(quantity: int) -> Array[Cell]:
	var cells_count: int = get_cells_count()
	var diff: int = cells_count - quantity
	var target: Array[Cell] = []
	
	if diff > 0:
		for i in range(quantity, cells_count):
			target.append(get_cell(i))
	
	return target


func get_cells_values() -> Array[String]:
	var texts: Array[String] = []
	
	for c in get_cells():
		texts.append(c.get_text())
	
	return texts


func get_cells_count() -> int:
	return cells.get_child_count()


func set_cell_control(index: int, control: Control) -> void:
	get_cell(index).set_control(control)


func set_cell_width(index: int, x: float) -> void:
	get_cell(index).custom_minimum_size.x = x


func set_cell_value(index: int, value: String) -> void:
	get_cell(index).set_text(value)


## Set cells quantity to [param quantity].[br]
## When adding cells, will attempt to use [param using] if it size match 
## the [b]exactly[/b] difference in cells.
func set_cells_quantity(quantity: int, using: Array[Cell] = []) -> void:
	var cells_count: int = get_cells_count()
	var diff: int = quantity - cells_count
	
	if diff > 0:
		if using.size() == diff:
			for c in using:
				add_cell(-1, c)
		else:
			for i in diff:
				add_cell(-1)
	elif diff < 0:
		for i in abs(diff):
			remove_cell(-1)


func set_cells_values(values: Array[String]) -> void:
	for i in min(values.size(), get_cells_count()):
		set_cell_value(i, values[i])


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
	
	if table.table_view:
		table.table_view.refresh_counters()
		UndoHelper.undo_redo.add_do_method(table.table_view.refresh_counters)
		UndoHelper.undo_redo.add_undo_method(table.table_view.refresh_counters)
	
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
	UndoHelper.undo_redo.add_undo_method(table.remove_row.bind(index))
	UndoHelper.undo_redo.add_undo_method(table.update_rows_label.bind(index))
	
	if table.table_view:
		table.table_view.refresh_counters()
		UndoHelper.undo_redo.add_do_method(table.table_view.refresh_counters)
		UndoHelper.undo_redo.add_undo_method(table.table_view.refresh_counters)
	
	UndoHelper.undo_redo.commit_action(false)


func _on_row_header_clear_requested() -> void:
	if table:
		table.focus_row(get_index())
	
	var values: Array[String] = get_cells_values()
	
	UndoHelper.undo_redo.create_action("Clear row")
	UndoHelper.undo_redo.add_do_method(clear_cells)
	UndoHelper.undo_redo.add_undo_method(set_cells_values.bind(values))
	UndoHelper.undo_redo.commit_action()


func _on_row_header_copy_requested() -> void:
	if table:
		table.focus_row(get_index())
	
	var values: Array[String] = get_cells_values()
	var text: String = CSVHelper.to_csv([values], true)
	
	DisplayServer.clipboard_set(text)


func _on_row_header_cut_requested() -> void:
	_on_row_header_copy_requested()
	_on_row_header_clear_requested()


func _on_row_header_delete_requested() -> void:
	if not table:
		return queue_free()
	
	var index: int = get_index()
	
	table.focus_row(index)
	
	UndoHelper.undo_redo.create_action("Delete row")
	UndoHelper.undo_redo.add_do_method(table.remove_row.bind(index))
	UndoHelper.undo_redo.add_do_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.add_undo_reference(self)
	UndoHelper.undo_redo.add_undo_method(table.add_row.bind(index, self))
	UndoHelper.undo_redo.add_undo_method(table.update_rows_label.bind(index))
	
	if table.table_view:
		UndoHelper.undo_redo.add_do_method(table.table_view.refresh_counters)
		UndoHelper.undo_redo.add_undo_method(table.table_view.refresh_counters)
	
	UndoHelper.undo_redo.commit_action()


func _on_row_header_fit_requested() -> void:
	row.custom_minimum_size.y = 0
	
	for c in get_cells():
		c.text_edit.scroll_fit_content_height = true
	
	# Safest way because we never know if row will really change.
	await get_tree().create_timer(0.1).timeout
	
	row.custom_minimum_size.y = row.size.y
	
	for c in get_cells():
		c.text_edit.scroll_fit_content_height = false


func _on_row_header_move_requested(from: RowHeader) -> void:
	if not table:
		return
	
	var from_index: int = table.find_row_index(from)
	
	if from_index == -1:
		return
	
	var to_index: int = get_index()
	var min_index: int = min(from_index, to_index)
	
	UndoHelper.undo_redo.create_action("Move row")
	UndoHelper.undo_redo.add_do_method(table.move_row.bind(from_index, to_index))
	UndoHelper.undo_redo.add_do_method(table.update_rows_label.bind(min_index))
	UndoHelper.undo_redo.add_undo_method(table.move_row.bind(to_index, from_index))
	UndoHelper.undo_redo.add_undo_method(table.update_rows_label.bind(min_index))
	UndoHelper.undo_redo.commit_action()


func _on_row_header_paste_requested() -> void:
	if table:
		table.focus_row(get_index())
	
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


func _on_row_header_minimum_size_changed() -> void:
	if not table:
		return
	
	var width: float = row_header.custom_minimum_size.x # NOTE: Not the custom_minimum_size.
	
	table.row_columns.set_header_width(width)
