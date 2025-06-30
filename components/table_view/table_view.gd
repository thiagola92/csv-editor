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
## - column viewer: [ColumnViewer][br]
## - row viewer: [RowViewer][br]
## - table: [Table][br]
## - table bar: [TableBar][br]
## [br]
class_name TableView
extends VBoxContainer


@onready var scroll_container: ScrollContainer = %ScrollContainer

@onready var table: Table = %Table

@onready var table_bar: TableBar = $TableBar


###############################################################
# Table methods (UTILITY)
###############################################################


func get_table_values() -> Array[Array]:
	return table.get_rows_values()


## Get the everything that will be target if table is resized to
## [param]rows[/parma] and [param]columns[/parma].[br]
## Helps with undoing & redoing [method set_table_size].
func get_table_targets(rows: int, columns: int) -> TableTargets:
	var targets: TableTargets = TableTargets.new()
	
	targets.columns = table.row_columns.get_columns_target(columns)
	
	for r in table.get_rows():
		var array_cells: Array
		array_cells.assign(r.get_cells_target(columns))
		targets.cells.append(array_cells)
	
	targets.rows = table.get_rows_target(rows)
	
	return targets


func recreate_table() -> void:
	table.queue_free()
	
	table = Table.new()
	table.table_view = self
	
	scroll_container.add_child(table)


func set_table_size(rows: int, columns: int, using: TableTargets = TableTargets.new()) -> void:
	table.row_columns.set_columns_quantity(columns, using.columns)
	table.row_columns.update_columns_label()
	
	if using.cells.size() == table.get_rows_count():
		for i in table.get_rows_count():
			var r = table.get_row(i)
			var a: Array[Cell] = []
			a.assign(using.cells[i])
			r.set_cells_quantity(columns, a)
	else:
		for r in table.get_rows():
			r.set_cells_quantity(columns)
	
	table.set_rows_quantity(rows, using.rows)
	table.update_rows_label()


func set_table_values(values: Array[Array]) -> void:
	table.set_rows_values(values)


class TableTargets:
	var columns: Array[ColumnHeader] = []
	var cells: Array[Array] = []
	var rows: Array[RowCells] = []


###############################################################
# TableBar methods (UTILITY)
###############################################################


func refresh_counters() -> void:
	table_bar.set_row_counter(table.get_rows_count())
	table_bar.set_column_counter(table.row_columns.get_columns_count())
