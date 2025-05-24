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


signal add_row_requested(index: int)

signal row_header_width_changed

const CellScene: PackedScene = preload("../cell/cell.tscn")

@onready var _row_header: RowHeader = %RowHeader

@onready var _cells: HBoxContainer = %Cells


func add_cell(index: int) -> void:
	var cell: Cell = CellScene.instantiate()
	
	_cells.add_child(cell)
	_cells.move_child(cell, index)


func get_cells_count() -> int:
	return _cells.get_child_count()


func get_row_header_width() -> float:
	return _row_header.custom_minimum_size.x


func set_cell_width(index: int, x: float) -> void:
	(_cells.get_child(index) as Cell).custom_minimum_size.x = x


func set_row_header_width(x: float) -> void:
	_row_header.custom_minimum_size.x = x


func set_text(text: String) -> void:
	_row_header.set_text(text)


func _on_row_header_add_above_requested() -> void:
	if get_index() > 0:
		add_row_requested.emit(get_index() - 1)
	else:
		add_row_requested.emit(0)


func _on_row_header_add_below_requested() -> void:
	add_row_requested.emit(get_index() + 1)


func _on_row_header_minimum_size_changed() -> void:
	row_header_width_changed.emit()
