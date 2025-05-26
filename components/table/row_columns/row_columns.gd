## Represent the row with all columns headers.
## 
## [codeblock]
## | empty | column 0 | column 1 | column 2 | ... | column X |
## | ---------------------- separator ----------------------- |
## [/codeblock]
## [br]
## - empty: [EmptyHeader][br]
## - column: [ColumnHeader][br]
## - separator: [RowSeparator][br]
## [br]
## [b]Note:[/b] Almost the same as [RowCells] but using [ColumnHeader] instead of [Cell].
class_name RowColumns
extends VBoxContainer


const ColumnHeaderScene: PackedScene = preload("../column_header/column_header.tscn")

@export var table: Table

@onready var empty_header: EmptyHeader = %EmptyHeader

@onready var columns: HBoxContainer = %Columns


###############################################################
# EmptyHeader methods
###############################################################


func set_header_width(x: float) -> void:
	# Update size too because RowCells will use it
	# to set their custom_minimum_size.
	empty_header.size.x = x
	empty_header.custom_minimum_size.x = x


###############################################################
# Column methods (CORE)
# add_xxx, get_xxx, move_xxx, remove_xxx and their plural version.
###############################################################


func add_column(index: int) -> void:
	var column_header: ColumnHeader = ColumnHeaderScene.instantiate()
	
	columns.add_child(column_header)
	columns.move_child(column_header, index)
	
	column_header.add_after_requested.connect(_on_column_header_add_after_requested)
	column_header.add_before_requested.connect(_on_column_header_add_before_requested)
	column_header.clear_requested.connect(_on_column_header_clear_requested)
	column_header.copy_requested.connect(_on_column_header_copy_requested)
	column_header.cut_requested.connect(_on_column_header_cut_requested)
	column_header.delete_requested.connect(_on_column_header_delete_requested)
	column_header.paste_requested.connect(_on_column_header_paste_requested)
	column_header.minimum_size_changed.connect(
		_on_column_header_minimum_size_changed.bind(column_header))


func get_column(index: int) -> ColumnHeader:
	return columns.get_child(index) as ColumnHeader


func get_columns() -> Array[ColumnHeader]:
	var array: Array[ColumnHeader]
	array.assign(columns.get_children())
	return array


func move_column(from: int, to: int) -> void:
	columns.move_child(get_column(from), to)


func remove_column(index: int) -> void:
	get_column(index).queue_free()


###############################################################
# Column methods (UTILITY)
###############################################################


func get_columns_count() -> int:
	return columns.get_child_count()


func get_column_width(index: int) -> float:
	return get_column(index).size.x # NOTE: Not the custom_minimum_size.


func get_columns_width(start: int, end: int) -> Array[float]:
	var widths: Array[float] = []
	
	for i in range(start, end):
		widths.append(get_column(i).size.x) # NOTE: Not the custom_minimum_size.
		
	return widths


func set_column_width(index: int, x: float) -> void:
	get_column(index).custom_minimum_size.x = x


func update_columns_label(start: int = 0) -> void:
	for i in range(start, get_columns_count()):
		get_column(i).update_label(i)


###############################################################
# EmptyHeader signals
###############################################################


func _on_empty_header_add_column_requested() -> void:
	var index: int = get_columns_count()
	
	add_column(index)
	update_columns_label(index)
	
	if not table:
		return
	
	var width: float = get_column_width(index)
	
	for r in table.get_rows():
		r.add_cell(index)
		r.set_cell_width(index, width)


func _on_empty_header_add_row_requested() -> void:
	if not table:
		return
	
	var index: int = table.get_rows_count()
	
	table.add_row(index)
	table.update_rows_label(index)


func _on_empty_header_clear_requested() -> void:
	if not table:
		return
	
	for r in table.get_rows():
		r.clear_cells()


func _on_empty_header_copy_requested() -> void:
	if not table:
		return


func _on_empty_header_cut_requested() -> void:
	if not table:
		return


func _on_empty_header_paste_requested() -> void:
	if not table:
		return


func _on_empty_header_minimum_size_changed() -> void:
	if not table:
		return
	
	var width: float = empty_header.size.x # NOTE: Not the custom_minimum_size.

	for r in table.get_rows():
		r.set_header_width(width)


###############################################################
# ColumnHeader signals
###############################################################


func _on_column_header_add_after_requested(index: int) -> void:
	index += 1
	
	add_column(index)
	update_columns_label(index)
	
	if not table:
		return
	
	var width: float = get_column_width(index)
	
	for r in table.get_rows():
		r.add_cell(index)
		r.set_cell_width(index, width)


func _on_column_header_add_before_requested(index: int) -> void:
	add_column(index)
	update_columns_label(index)
	
	if not table:
		return
	
	var width: float = get_column_width(index)
	
	for r in table.get_rows():
		r.add_cell(index)
		r.set_cell_width(index, width)


func _on_column_header_clear_requested(index: int) -> void:
	if not table:
		return
	
	for r in table.get_rows():
		r.clear_cell(index)


func _on_column_header_copy_requested(index: int) -> void:
	if not table:
		return


func _on_column_header_cut_requested(index: int) -> void:
	if not table:
		return


func _on_column_header_delete_requested(index: int) -> void:
	if not table:
		return
	
	for r in table.get_rows():
		r.remove_cell(index)


func _on_column_header_paste_requested(index: int) -> void:
	if not table:
		return


func _on_column_header_minimum_size_changed(column_header: ColumnHeader) -> void:
	if not table:
		return
	
	var index: int = column_header.get_index()
	var width: float = get_column_width(index)
	
	for r in table.get_rows():
		r.set_cell_width(index, width)
