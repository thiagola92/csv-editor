## Holds all rows and take care of interactions between them.
##
## [codeblock]
## | empty | column 0 | column 1 | column 2 | ... | column X |
## | ------------------------------------------------------- |
## | row 0 | cell 0   | cell 1   | cell 2   | ... | cell X   |
## | ------------------------------------------------------- |
## | row 1 | cell 0   | cell 1   | cell 2   | ... | cell X   |
## | ------------------------------------------------------- |
## | row 2 | cell 0   | cell 1   | cell 2   | ... | cell X   |
## | ------------------------------------------------------- |
## [/codeblock]
class_name Table
extends VBoxContainer


const RowCellsScene: PackedScene = preload("row_cells/row_cells.tscn")

@onready var row_columns: RowColumns = $RowColumns

@onready var rows: VBoxContainer = $Rows


###############################################################
# Row methods
###############################################################


func add_row(index: int) -> void:
	var row_cells: RowCells = RowCellsScene.instantiate()
	var columns_count: int = row_columns.get_columns_count()
	
	rows.add_child(row_cells)
	rows.move_child(row_cells, index)
	
	for i in columns_count:
		var w: float = row_columns.get_column_width(i)
		
		row_cells.add_cell(i)
		row_cells.set_cell_width(i, w)


func get_rows() -> Array[RowCells]:
	var array: Array[RowCells]
	array.assign(rows.get_children())
	return array


func get_rows_count() -> int:
	return rows.get_child_count()


func move_row(from: int, to: int) -> void:
	var row_cells := rows.get_child(from) as RowCells
	rows.move_child(row_cells, to)


func remove_row(index: int) -> void:
	var row_cells := rows.get_child(index) as RowCells
	row_cells.queue_free()


func update_row_label(index: int) -> void:
	var row_cells := rows.get_child(index) as RowCells
	row_cells.row_header.update_label(index)


func update_rows_label(start: int = 0) -> void:
	for i in range(start, get_rows_count()):
		update_row_label(i)
