class_name MenuHelper
extends Node


static func add_shortcut(menu: PopupMenu, id: int, action: String) -> void:
	var shortcut := Shortcut.new()
	var index: int = menu.get_item_index(id)
	shortcut.events = ProjectSettings.get_setting(action).events
	menu.set_item_shortcut(index, shortcut)
