## Represent the row with all columns headers.
## 
## [codeblock]
## |        | column 0 | column 1 | column 2 | ... | column X |
## | ---------------------- separator ----------------------- |
## [/codeblock]
## [br]
## - (empty space): [RowHeader] without text[br]
## - column: [Column][br]
## - separator: [RowSeparator][br]
## [br]
## [b]Note:[/b] Almost the same as [RowCells] but using [Column] instead of [Cell].
class_name RowColumns
extends VBoxContainer
