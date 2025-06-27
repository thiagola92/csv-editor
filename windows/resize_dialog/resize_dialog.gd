class_name ResizeDialog
extends ConfirmationDialog


@export var table_bar: TableBar


func _ready() -> void:
	get_ok_button().modulate = Color.html("#c64600")


func _on_confirmed() -> void:
	if not table_bar:
		return
	
	table_bar.table_view.set_table_size(
		int(table_bar.rows_counter.value),
		int(table_bar.columns_counter.value)
	)
