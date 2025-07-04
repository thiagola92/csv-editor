## Let the user interact with the column width.
class_name ColumnSeparator
extends VSeparator


## Set to the Control that you want the custom_minimum_size changed.
@export var control: Control

var initial_x_position: float

var initial_x_size: float


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return set_process(false)
	
	resize_column()


func resize_column() -> void:
	var distance: float = get_global_mouse_position().x - initial_x_position
	
	if control:
		control.custom_minimum_size.x = initial_x_size + distance
		
		await control.item_rect_changed
		control.minimum_size_changed.emit()


func reset_column() -> void:
	set_process(false)
	
	if control:
		control.custom_minimum_size.x = 0
		
		await control.item_rect_changed
		control.minimum_size_changed.emit()


func follow_mouse() -> void:
	set_process(true)
	
	initial_x_position = get_global_mouse_position().x
	
	if control:
		initial_x_size = control.size.x


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_gui_mouse_button(event)


func _on_gui_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		reset_column()
	elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		follow_mouse()
