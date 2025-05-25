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


signal column_added(index: int)

signal add_row_requested

signal clear_requested

signal copy_requested

signal cut_requested

signal paste_requested

signal empty_header_width_changed

signal column_header_width_changed(index: int)

const ColumnHeaderScene: PackedScene = preload("../column_header/column_header.tscn")

@onready var empty_header: EmptyHeader = %EmptyHeader

@onready var _columns: HBoxContainer = %Columns


func get_columns_count() -> int:
	return _columns.get_child_count()


func get_column_width(index: int) -> float:
	return (_columns.get_child(index) as ColumnHeader).size.x


func get_empty_header_width() -> float:
	return empty_header.custom_minimum_size.x


func set_empty_header_width(x: float) -> void:
	empty_header.custom_minimum_size.x = x


func _on_empty_header_add_column_requested() -> void:
	var column_header: ColumnHeader = ColumnHeaderScene.instantiate()
	
	_columns.add_child(column_header)
	column_header.set_text(str(column_header.get_index()))
	
	column_header.add_after_requested.connect(
		_on_column_header_add_after_requested.bind(column_header)
	)
	
	column_header.add_before_requested.connect(
		_on_column_header_add_after_requested.bind(column_header)
	)
	
	column_header.clear_requested.connect(
		_on_column_header_clear_requested.bind(column_header)
	)
	
	column_header.copy_requested.connect(
		_on_column_header_copy_requested.bind(column_header)
	)
	
	column_header.cut_requested.connect(
		_on_column_header_cut_requested.bind(column_header)
	)
	
	column_header.paste_requested.connect(
		_on_column_header_paste_requested.bind(column_header)
	)
	
	column_header.minimum_size_changed.connect(
		_on_column_header_minimum_size_changed.bind(column_header)
	)
	
	column_added.emit(_columns.get_child_count() - 1)


func _on_empty_header_add_row_requested() -> void:
	add_row_requested.emit()


func _on_empty_header_clear_requested() -> void:
	clear_requested.emit()


func _on_empty_header_copy_requested() -> void:
	copy_requested.emit()


func _on_empty_header_cut_requested() -> void:
	cut_requested.emit()


func _on_empty_header_paste_requested() -> void:
	paste_requested.emit()


func _on_empty_header_minimum_size_changed() -> void:
	empty_header_width_changed.emit()


func _on_column_header_add_after_requested(column_header: ColumnHeader) -> void:
	pass


func _on_column_header_add_before_requested(column_header: ColumnHeader) -> void:
	pass


func _on_column_header_clear_requested(column_header: ColumnHeader) -> void:
	pass


func _on_column_header_copy_requested(column_header: ColumnHeader) -> void:
	pass


func _on_column_header_cut_requested(column_header: ColumnHeader) -> void:
	pass


func _on_column_header_paste_requested(column_header: ColumnHeader) -> void:
	pass


func _on_column_header_minimum_size_changed(column_header: ColumnHeader) -> void:
	column_header_width_changed.emit(column_header.get_index())
