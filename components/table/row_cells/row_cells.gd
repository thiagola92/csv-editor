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
# Cell methods
###############################################################


func add_cell(index: int) -> void:
	var cell: Cell = CellScene.instantiate()
	
	cells.add_child(cell)
	cells.move_child(cell, index)


func get_cells() -> Array[Cell]:
	var array: Array[Cell]
	array.assign(cells.get_children())
	return array


func move_cell(from: int, to: int) -> void:
	var cell = cells.get_child(from) as Cell
	cells.move_child(cell, to)


func remove_cell(index: int) -> void:
	var cell := cells.get_child(index) as Cell
	cell.queue_free()


func set_cell_width(index: int, x: float) -> void:
	var cell := cells.get_child(index) as Cell
	cell.custom_minimum_size.x = x


###############################################################
# RowHeader signals
###############################################################


func _on_row_header_add_above_requested() -> void:
	if not table:
		return


func _on_row_header_add_below_requested() -> void:
	if not table:
		return


func _on_row_header_clear_requested() -> void:
	for cell: Cell in cells.get_children():
		cell.clear()


func _on_row_header_copy_requested() -> void:
	var values: Array[String] = []
	
	for cell: Cell in cells.get_children():
		values.append(cell.text)
	
	# TODO: Transform in one line like
	# value1,value2,value3,value4
	# and move to user CTRL+C.
	# NOTE: maybe put in one function
	# because "cut" also needs.


func _on_row_header_cut_requested() -> void:
	pass # Replace with function body.


func _on_row_header_delete_requested() -> void:
	queue_free()


func _on_row_header_paste_requested() -> void:
	pass # Replace with function body.


func _on_row_header_minimum_size_changed() -> void:
	if not table:
		return
