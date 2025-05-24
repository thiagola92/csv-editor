## Let the user interact with the column width.
class_name ColumnSeparator
extends VSeparator


## Set to the Control that you want the minimum_size.x changed.
@export var column: Control

var _initial_x_position: float

var _initial_x_size: float


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return set_process(false)
	
	_resize_column()


func _follow_mouse() -> void:
	set_process(true)
	
	_initial_x_position = get_global_mouse_position().x
	
	if column:
		_initial_x_size = column.size.x


func _reset_column() -> void:
	if column:
		column.custom_minimum_size.x = 0


func _resize_column() -> void:
	var distance: float = get_global_mouse_position().x - _initial_x_position
	
	if column:
		column.custom_minimum_size.x = _initial_x_size + distance


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		_reset_column()
	elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_follow_mouse()
