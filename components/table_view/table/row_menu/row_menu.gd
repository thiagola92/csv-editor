class_name RowMenu
extends PopupMenu


enum {
	MENU_CUT = 0,
	MENU_COPY = 1,
	MENU_PASTE = 2,
	MENU_ADD_ABOVE = 3,
	MENU_ADD_BELOW = 4,
	MENU_CLEAR = 5,
	MENU_DELETE = 6,
}


func _init() -> void:
	visible = false


func _ready() -> void:
	MenuHelper.add_shortcut(self, MENU_CUT, "input/ui_cut")
	MenuHelper.add_shortcut(self, MENU_COPY, "input/ui_copy")
	MenuHelper.add_shortcut(self, MENU_PASTE, "input/ui_paste")
