## Show the column index and provide a menu for the user interact with the column.
class_name ColumnHeader
extends HBoxContainer


@onready var _label: Label = %Label


func set_text(index: int) -> void:
	_label.text = str(index)
