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


signal add_row_requested

signal column_added(index: int)

signal empty_header_width_changed

signal column_header_width_changed(index: int)

const ColumnHeaderScene: PackedScene = preload("../column_header/column_header.tscn")

@onready var _empty_header: EmptyHeader = %EmptyHeader

@onready var _columns: HBoxContainer = %Columns


func get_columns_count() -> int:
	return _columns.get_child_count()


func get_column_width(index: int) -> float:
	return (_columns.get_child(index) as ColumnHeader).size.x


func _on_empty_header_add_column_requested() -> void:
	var column_header: ColumnHeader = ColumnHeaderScene.instantiate()
	
	_columns.add_child(column_header)
	column_header.set_text(str(column_header.get_index()))
	column_header.minimum_size_changed.connect(
		_on_column_header_width_changed.bind(column_header)
	)
	column_added.emit(_columns.get_child_count() - 1)


func _on_empty_header_add_row_requested() -> void:
	add_row_requested.emit()


func _on_empty_header_minimum_size_changed() -> void:
	empty_header_width_changed.emit()


func _on_column_header_width_changed(column_header: ColumnHeader) -> void:
	column_header_width_changed.emit(column_header.get_index())
