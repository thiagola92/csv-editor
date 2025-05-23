## Show the column index and provide a menu for the user interact with the column.
class_name ColumnHeader
extends CenterContainer


@export var empty: bool

@onready var _label: Label = $Label


func _ready() -> void:
	if empty:
		_label.text = "" 


func set_text(index: int) -> void:
	_label.text = "" if empty else str(index)
