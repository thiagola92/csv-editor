class_name TableView
extends VBoxContainer


@onready var table: Table = %Table


###############################################################
# Table methods (UTILITY)
###############################################################


func get_table_values() -> Array[Array]:
	return table.get_rows_values()


func set_table_size(rows: int, columns: int) -> void:
	for c in columns:
		table.row_columns.add_column(c)
	
	for r in rows:
		table.add_row(r)


func set_table_values(values: Array[Array]) -> void:
	table.set_rows_values(values)
