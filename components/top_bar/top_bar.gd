extends MenuBar


signal open_requested

signal save_requested

signal save_as_requested

signal quit_requested

enum {
	MENU_OPEN = 0,
	MENU_SAVE = 1,
	MENU_SAVE_AS = 2,
	MENU_QUIT = 3,
}

@onready var file_menu: PopupMenu = $FileMenu


func _ready() -> void:
	MenuHelper.add_shortcut(file_menu, MENU_OPEN, "input/ui_open")
	MenuHelper.add_shortcut(file_menu, MENU_SAVE, "input/ui_save")
	MenuHelper.add_shortcut(file_menu, MENU_SAVE_AS, "input/ui_save_as")
	MenuHelper.add_shortcut(file_menu, MENU_QUIT, "input/ui_quit")


func _on_file_id_pressed(id: int) -> void:
	match id:
		MENU_OPEN:
			open_requested.emit()
		MENU_SAVE:
			save_requested.emit()
		MENU_SAVE_AS:
			save_as_requested.emit()
		MENU_QUIT:
			quit_requested.emit()
