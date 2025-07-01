## Improve the visualization of the table.
##
## [codeblock]
## |           column viewer            |
## | ---------------------------------- |
## |            |                       |
## |            |                       |
## | row viewer |         table         |
## |            |                       |
## |            |                       |
## | ---------------------------------- |
## |           table bar                |
## [/codeblock]
## [br]
## - column viewer: [ColumnViewer] *TBD[br]
## - row viewer: [RowViewer] *TBD[br]
## - table: [Table][br]
## - table bar: [TableBar][br]
## [br]
class_name TableView
extends VBoxContainer


const TableScene: PackedScene = preload("res://components/table_view/table/table.tscn")

@onready var scroll_container: ScrollContainer = %ScrollContainer

@onready var table: Table = %Table

@onready var table_bar: TableBar = $TableBar


###############################################################
# Table methods (UTILITY)
###############################################################


func get_table_values() -> Array[Array]:
	return table.get_rows_values()


## Get the everything that will be target if table is resized to
## [param x] rows and [param y] columns.[br]
## [br]
## [b]Note[/b]: Helps with undoing & redoing [method set_table_size].
func get_table_targets(x: int, y: int) -> TableTargets:
	var targets: TableTargets = TableTargets.new()
	
	targets.columns = table.row_columns.get_columns_target(x)
	
	for r in table.get_rows():
		var array_cells: Array
		array_cells.assign(r.get_cells_target(x))
		targets.cells.append(array_cells)
	
	targets.rows = table.get_rows_target(y)
	
	return targets


func recreate_table() -> void:
	table.queue_free()
	
	table = TableScene.instantiate()
	table.table_view = self
	
	scroll_container.add_child(table)


## Set table size to [param x] columns and [param y] rows.[br]
## If [param using] is passed, it will attempt to use it nodes when adding to table.[br]
## [br]
## [b]Note[/b]: No tests were made to make sure that undo & redo works when resizing
## both x and y at same time.
func set_table_size(x: int, y: int, using: TableTargets = TableTargets.new()) -> void:
	table.row_columns.set_columns_quantity(x, using.columns)
	table.row_columns.update_columns_label()
	
	if using.cells.size() == table.get_rows_count():
		for i in table.get_rows_count():
			var r = table.get_row(i)
			var a: Array[Cell] = []
			a.assign(using.cells[i])
			r.set_cells_quantity(x, a)
	else:
		for r in table.get_rows():
			r.set_cells_quantity(x)
	
	table.set_rows_quantity(y, using.rows)
	table.update_rows_label()


func set_table_values(values: Array[Array]) -> void:
	table.set_rows_values(values)


class TableTargets:
	var columns: Array[ColumnHeader] = []
	var cells: Array[Array] = []
	var rows: Array[RowCells] = []
	
	func is_empty() -> bool:
		for c in cells:
			if not c.is_empty():
				return false
		return columns.is_empty() and rows.is_empty()


###############################################################
# TableBar methods (UTILITY)
###############################################################


func refresh_counters() -> void:
	table_bar.set_row_counter(table.get_rows_count())
	table_bar.set_column_counter(table.row_columns.get_columns_count())
