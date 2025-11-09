## Let the user interact with the row height.
class_name RowSeparator
extends HSeparator


## Set to the Control that you want the custom_minimum_size changed.
@export var control: Control

var initial_y_position: float

var initial_y_size: float


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return set_process(false)
	
	resize_row()


func resize_row() -> void:
	var distance: float = get_global_mouse_position().y - initial_y_position
	set_row_height(initial_y_size + distance)


func reset_row() -> void:
	set_process(false)
	set_row_height(0)


func set_row_height(y: float) -> void:
	if control:
		control.custom_minimum_size.y = y
		
		await control.item_rect_changed
		control.minimum_size_changed.emit()


func follow_mouse() -> void:
	set_process(true)
	
	initial_y_position = get_global_mouse_position().y
	
	if control:
		initial_y_size = control.size.y


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		reset_row()
	elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		follow_mouse()
