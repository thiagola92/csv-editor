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
## [/codeblock]
## [br]
## - column viewer: [ColumnViewer][br]
## - row viewer: [RowViewer][br]
## - table: [Table][br]
## [br]
class_name TableView
extends VBoxContainer


@onready var scroll_container: ScrollContainer = %ScrollContainer

@onready var table: Table = %Table

@onready var rows_counter: SpinBox = %RowsCounter

@onready var columns_counter: SpinBox = %ColumnsCounter


###############################################################
# Table methods (UTILITY)
###############################################################


func get_table_values() -> Array[Array]:
	return table.get_rows_values()


func recreate_table() -> void:
	table.queue_free()
	
	table = Table.new()
	table.table_view = self
	
	scroll_container.add_child(table)


func set_table_size(rows: int, columns: int) -> void:
	table.row_columns.set_columns_quantity(columns)
	table.row_columns.update_columns_label()
	table.set_rows_quantity(rows)
	table.update_rows_label()


func set_table_values(values: Array[Array]) -> void:
	table.set_rows_values(values)


###############################################################
# Counters methods (UTILITY)
###############################################################


func refresh_counters() -> void:
	rows_counter.value = table.get_rows_count()
	columns_counter.value = table.row_columns.get_columns_count()
