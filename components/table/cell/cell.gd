## Holds one of the values in a CSV line.
class_name Cell
extends TextEdit


const CellWindowScene: PackedScene = preload("../cell_window/cell_window.tscn")

var _cell_window: CellWindow


func _ready() -> void:
	hide_scroll_grabber()
	
	CellMenu.setup(get_menu())
	
	get_menu().id_pressed.connect(_on_id_pressed)


func hide_scroll_grabber() -> void:
	get_v_scroll_bar().add_theme_stylebox_override("scroll", StyleBoxEmpty.new())
	get_v_scroll_bar().add_theme_stylebox_override("scroll_focus", StyleBoxEmpty.new())
	get_v_scroll_bar().add_theme_stylebox_override("grabber", StyleBoxEmpty.new())
	get_v_scroll_bar().add_theme_stylebox_override("grabber_highlight", StyleBoxEmpty.new())
	get_v_scroll_bar().add_theme_stylebox_override("grabber_pressed", StyleBoxEmpty.new())
	get_h_scroll_bar().add_theme_stylebox_override("scroll", StyleBoxEmpty.new())
	get_h_scroll_bar().add_theme_stylebox_override("scroll_focus", StyleBoxEmpty.new())
	get_h_scroll_bar().add_theme_stylebox_override("grabber", StyleBoxEmpty.new())
	get_h_scroll_bar().add_theme_stylebox_override("grabber_highlight", StyleBoxEmpty.new())
	get_h_scroll_bar().add_theme_stylebox_override("grabber_pressed", StyleBoxEmpty.new())


func reset_scroll_position() -> void:
	get_v_scroll_bar().value = 0
	get_h_scroll_bar().value = 0


func focus_cell_window() -> void:
	if _cell_window:
		return _cell_window.grab_focus()
	
	_cell_window = CellWindowScene.instantiate()
	_cell_window.cell = self
	add_child(_cell_window)


func _on_id_pressed(id: int) -> void:
	match id:
		CellMenu.MENU_WINDOW:
			focus_cell_window()


func _on_focus_exited() -> void:
	reset_scroll_position()
	editable = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_on_mouse_button(event)


func _on_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		editable = true
		caret_blink = true
