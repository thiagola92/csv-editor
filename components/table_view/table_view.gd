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


###############################################################
# Table methods (UTILITY)
###############################################################


func get_table_values() -> Array[Array]:
	return table.get_rows_values()


func recreate_table() -> void:
	table.queue_free()
	table = Table.new()
	scroll_container.add_child(table)


func set_table_size(rows: int, columns: int) -> void:
	table.row_columns.set_columns_quantity(columns)
	table.row_columns.update_columns_label()
	table.set_rows_quantity(rows)
	table.update_rows_label()


func set_table_values(values: Array[Array]) -> void:
	table.set_rows_values(values)
