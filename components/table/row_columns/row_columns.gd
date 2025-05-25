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


func get_columns_count() -> int:
	return columns.get_child_count()


func get_column_width(index: int) -> float:
	return (columns.get_child(index) as ColumnHeader).size.x


func get_empty_header_width() -> float:
	return empty_header.custom_minimum_size.x


func set_empty_header_width(x: float) -> void:
	empty_header.custom_minimum_size.x = x


# ----------- Empty Header Signals -----------


func _on_empty_header_add_column_requested() -> void:
	var column_header: ColumnHeader = ColumnHeaderScene.instantiate()
	
	columns.add_child(column_header)
	column_header.label.text = str(column_header.get_index())
	column_header.add_after_requested.connect(_on_column_header_add_after_requested)
	column_header.add_before_requested.connect(_on_column_header_add_before_requested)
	column_header.clear_requested.connect(_on_column_header_clear_requested)
	column_header.copy_requested.connect(_on_column_header_copy_requested)
	column_header.cut_requested.connect(_on_column_header_cut_requested)
	column_header.delete_requested.connect(_on_column_header_delete_requested)
	column_header.paste_requested.connect(_on_column_header_paste_requested)
	column_header.minimum_size_changed.connect(
		_on_column_header_minimum_size_changed.bind(column_header)
	)
	
	#column_added.emit(columns.get_child_count() - 1)


func _on_empty_header_add_row_requested() -> void:
	pass


func _on_empty_header_clear_requested() -> void:
	pass


func _on_empty_header_copy_requested() -> void:
	pass


func _on_empty_header_cut_requested() -> void:
	pass


func _on_empty_header_paste_requested() -> void:
	pass


func _on_empty_header_minimum_size_changed() -> void:
	pass


# ----------- Column Header Signals -----------


func _on_column_header_add_after_requested(index: int) -> void:
	pass


func _on_column_header_add_before_requested(index: int) -> void:
	pass


func _on_column_header_minimum_size_changed(column_header: ColumnHeader) -> void:
	#column_header_width_changed.emit(column_header.get_index())
	pass


func _on_column_header_clear_requested(index: int) -> void:
	pass # Replace with function body.


func _on_column_header_copy_requested(index: int) -> void:
	pass # Replace with function body.


func _on_column_header_cut_requested(index: int) -> void:
	pass # Replace with function body.


func _on_column_header_delete_requested(index: int) -> void:
	pass # Replace with function body.


func _on_column_header_paste_requested(index: int) -> void:
	pass # Replace with function body.
