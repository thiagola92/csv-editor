class_name EmptyMenu
extends PopupMenu


enum {
	MENU_CUT = 0,
	MENU_COPY = 1,
	MENU_PASTE = 2,
	MENU_ADD_COLUMN = 3,
	MENU_ADD_ROW = 4,
	MENU_CLEAR = 5,
}


func _init() -> void:
	visible = false
