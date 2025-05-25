## Represents a row of cells.
##
## [codeblock]
## | row 0 | cell 0 | cell 1 | cell 2 | ... | cell X |
## | ------------------ separator ------------------ |
## [/codeblock]
## [br]
## - header: [RowHeader][br]
## - cell: [Cell][br]
## - separator: [RowSeparator][br]
class_name RowCells
extends VBoxContainer


const CellScene: PackedScene = preload("../cell/cell.tscn")

@export var table: Table

@onready var row_header: RowHeader = %RowHeader

@onready var cells: HBoxContainer = %Cells
