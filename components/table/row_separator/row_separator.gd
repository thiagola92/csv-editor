## Let the user interact with the row height.
class_name RowSeparator
extends HSeparator


## Set to the Control that you want the minimum_size.y changed.
@export var row: Control

var _initial_y_position: float

var _initial_y_size: float


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return set_process(false)
	
	_resize_row()


func _follow_mouse() -> void:
	set_process(true)
	
	_initial_y_position = get_global_mouse_position().y
	
	if row:
		_initial_y_size = row.size.y


func _reset_row() -> void:
	if row:
		row.custom_minimum_size.y = 0


func _resize_row() -> void:
	var distance: float = get_global_mouse_position().y - _initial_y_position
	
	if row:
		row.custom_minimum_size.y = _initial_y_size + distance


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		_reset_row()
	elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_follow_mouse()
