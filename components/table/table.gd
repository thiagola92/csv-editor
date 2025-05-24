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

@onready var _row_columns: RowColumns = $RowColumns

@onready var _rows: VBoxContainer = $Rows


func _on_row_columns_add_row_requested() -> void:
	var row_cells: RowCells = RowCellsScene.instantiate()
	var values: Array[String]
	
	_rows.add_child(row_cells)
	values.resize(_row_columns.get_columns_count())
	row_cells.set_text(str(row_cells.get_index()))
	row_cells.row_header_width_changed.connect(
		_on_row_cells_row_header_width_changed.bind(row_cells)
	)
	
	for i in _row_columns.get_columns_count():
		row_cells.add_cell(i)
		row_cells.set_cell_width(i, _row_columns.get_column_width(i))


func _on_row_columns_column_added(index: int) -> void:
	var width: float = _row_columns.get_column_width(index)
	
	for rc: RowCells in _rows.get_children():
		rc.add_cell(index)
		rc.set_cell_width(index, width)


func _on_row_columns_column_header_width_changed(index: int) -> void:
	var width: float = _row_columns.get_column_width(index)
	
	for rc: RowCells in _rows.get_children():
		rc.set_cell_width(index, width)


func _on_row_columns_empty_header_width_changed() -> void:
	var width: float = _row_columns.get_empty_header_width()
	
	for rc: RowCells in _rows.get_children():
		rc.set_row_header_width(width)


func _on_row_cells_row_header_width_changed(row_cells: RowCells) -> void:
	_row_columns.set_empty_header_width(
		row_cells.get_row_header_width()
	)
