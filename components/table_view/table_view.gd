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
	scroll_container.remove_child(table)
	table = Table.new()
	scroll_container.add_child(table)


func set_table_size(rows: int, columns: int) -> void:
	var rows_diff: int = rows - table.get_rows_count()
	var columns_diff: int = columns - table.row_columns.get_columns_count()
	var row_op: Callable = table.add_row if rows_diff > 0 else table.remove_row
	var colmun_op: Callable = table.row_columns.add_column if columns_diff > 0 \
		else table.row_columns.remove_column
	
	for r in abs(rows_diff):
		row_op.call(-1)
	
	for c in abs(columns_diff):
		colmun_op.call(-1)


func set_table_values(values: Array[Array]) -> void:
	table.set_rows_values(values)
