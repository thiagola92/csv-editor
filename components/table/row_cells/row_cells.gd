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


func get_cells_count() -> int:
	return cells.get_child_count()


func set_cell_width(index: int, x: float) -> void:
	get_cell(index).custom_minimum_size.x = x


func clear_cell(index: int) -> void:
	get_cell(index).clear()
	get_cell(index).sync_window_text()


func clear_cells() -> void:
	for c in get_cells():
		c.clear()
		c.sync_window_text()


func copy_cells() -> void:
	var values: Array[String] = []
	
	for c in get_cells():
		values.append(c.text)
	
	var text: String = CSVHelper.to_csv([values], true)
	
	DisplayServer.clipboard_set(text)


func paste_cells() -> void:
	var text: String = DisplayServer.clipboard_get()
	var lines: Array[Array] = CSVHelper.from_text(text, true)
	
	for l in lines:
		for i in min(get_cells_count(), l.size()):
			get_cell(i).text = l[i]
			get_cell(i).sync_window_text()
		
		break # Stop after first line


###############################################################
# RowHeader signals
###############################################################


func _on_row_header_add_above_requested() -> void:
	if not table:
		return
	
	table.add_row(get_index())
	table.update_rows_label(get_index() - 1)


func _on_row_header_add_below_requested() -> void:
	if not table:
		return
	
	table.add_row(get_index() + 1)
	table.update_rows_label(get_index() + 1)


func _on_row_header_clear_requested() -> void:
	clear_cells()


func _on_row_header_copy_requested() -> void:
	copy_cells()


func _on_row_header_cut_requested() -> void:
	copy_cells()
	clear_cells()


func _on_row_header_delete_requested() -> void:
	queue_free()


func _on_row_header_paste_requested() -> void:
	paste_cells()


func _on_row_header_minimum_size_changed() -> void:
	if not table:
		return
	
	var width: float = row_header.custom_minimum_size.x # NOTE: Not the custom_minimum_size.
	
	table.row_columns.set_header_width(width)
