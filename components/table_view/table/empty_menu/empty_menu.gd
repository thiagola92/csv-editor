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
	MenuHelper.add_shortcut(self, MENU_CUT, "input/ui_cut")
	MenuHelper.add_shortcut(self, MENU_COPY, "input/ui_copy")
	MenuHelper.add_shortcut(self, MENU_PASTE, "input/ui_paste")
	MenuHelper.add_shortcut(self, MENU_UNDO, "input/ui_undo")
	MenuHelper.add_shortcut(self, MENU_REDO, "input/ui_redo")
