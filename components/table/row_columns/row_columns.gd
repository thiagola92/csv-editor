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
## [b]Note:[/b] Almost the same as [RowCells] but using [Column] instead of [Cell].
class_name RowColumns
extends VBoxContainer


func _on_empty_header_minimum_size_changed() -> void:
	print($Row/EmptyHeader.custom_minimum_size)
