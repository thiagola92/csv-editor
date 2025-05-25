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


func add_column(index: int) -> void:
	var column_header: ColumnHeader = ColumnHeaderScene.instantiate()
	
	columns.add_child(column_header)
	columns.move_child(column_header, index)


func get_columns_count() -> int:
	return columns.get_child_count()


func link_signals(column_header: ColumnHeader) -> void:
	column_header.add_after_requested.connect(_on_column_header_add_after_requested)
	column_header.add_before_requested.connect(_on_column_header_add_before_requested)
	column_header.clear_requested.connect(_on_column_header_clear_requested)
	column_header.copy_requested.connect(_on_column_header_copy_requested)
	column_header.cut_requested.connect(_on_column_header_cut_requested)
	column_header.delete_requested.connect(_on_column_header_delete_requested)
	column_header.paste_requested.connect(_on_column_header_paste_requested)
	column_header.minimum_size_changed.connect(
		_on_column_header_minimum_size_changed.bind(column_header))


func move_column(from: int, to: int) -> void:
	var column_header := columns.get_child(from) as ColumnHeader
	columns.move_child(column_header, to)


func remove_column(index: int) -> void:
	var column_header := columns.get_child(index) as ColumnHeader
	column_header.queue_free()


func set_column_width(index: int, x: float) -> void:
	var column_header := columns.get_child(index) as ColumnHeader
	column_header.custom_minimum_size.x = x


func update_column_label(index: int) -> void:
	var column_header := columns.get_child(index) as ColumnHeader
	column_header.update_label(index)


###############################################################


func _on_empty_header_add_column_requested() -> void:
	var index: int = get_columns_count()
	
	add_column(index)
	update_column_label(index)


func _on_empty_header_add_row_requested() -> void:
	if not table:
		return


func _on_empty_header_clear_requested() -> void:
	if not table:
		return


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


###############################################################


func _on_column_header_add_after_requested(index: int) -> void:
	add_column(index + 1)
	update_column_label(index + 1)


func _on_column_header_add_before_requested(index: int) -> void:
	add_column(index)
	update_column_label(index)


func _on_column_header_clear_requested(index: int) -> void:
	if not table:
		return


func _on_column_header_copy_requested(index: int) -> void:
	if not table:
		return


func _on_column_header_cut_requested(index: int) -> void:
	if not table:
		return


func _on_column_header_delete_requested(index: int) -> void:
	if not table:
		return


func _on_column_header_paste_requested(index: int) -> void:
	if not table:
		return


func _on_column_header_minimum_size_changed(column_header: ColumnHeader) -> void:
	if not table:
		return
