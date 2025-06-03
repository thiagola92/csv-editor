class_name EmptyMenu
extends PopupMenu


enum {
	MENU_CUT = 0,
	MENU_COPY = 1,
	MENU_PASTE = 2,
	MENU_ADD_COLUMN = 3,
	MENU_ADD_ROW = 4,
	MENU_CLEAR = 5,
	MENU_UNDO = 6,
	MENU_REDO = 7,
}


func _init() -> void:
	visible = false


func _ready() -> void:
	var s := Shortcut.new()
	var i1 := InputEventKey.new()
	var i2 := InputEventKey.new()
	i1.keycode = KEY_CTRL
	i2.keycode = KEY_X
	s.events = [i1, i2]
	set_item_shortcut(0, s)
