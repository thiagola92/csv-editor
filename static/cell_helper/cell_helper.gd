## Static methods to manage cell menu.
##
## This is all static because we can't replace the TextEditor PopupMenu.
## All that we can do is edit the existing one.
class_name CellHelper
extends RefCounted


const ICON_CUT := preload("./ActionCut.svg")

const ICON_COPY := preload("./ActionCopy.svg")

const ICON_PASTE := preload("./ActionPaste.svg")

const ICON_CLEAR := preload("./ActionClear.svg")

const ICON_UNDO := preload("./ActionUndo.svg")

const ICON_REDO := preload("./ActionRedo.svg")

const ICON_WINDOW := preload("./ActionWindow.svg")

const MENU_WINDOW = TextEdit.MENU_MAX + 1

static var empty_style: StyleBoxEmpty = StyleBoxEmpty.new()


static func setup_menu(menu: PopupMenu, is_window: bool = false) -> void:
	# Remove items that should be UndoRedo to all cells.
	menu.remove_item(menu.get_item_index(TextEdit.MENU_SUBMENU_TEXT_DIR))
	menu.remove_item(menu.get_item_index(TextEdit.MENU_DISPLAY_UCC))
	menu.remove_item(menu.get_item_index(TextEdit.MENU_SUBMENU_INSERT_UCC))
	menu.remove_item(menu.item_count - 1)
	
	# Add icons to existing items.
	menu.set_item_icon(menu.get_item_index(TextEdit.MENU_CUT), ICON_CUT)
	menu.set_item_icon(menu.get_item_index(TextEdit.MENU_COPY), ICON_COPY)
	menu.set_item_icon(menu.get_item_index(TextEdit.MENU_PASTE), ICON_PASTE)
	menu.set_item_icon(menu.get_item_index(TextEdit.MENU_CLEAR), ICON_CLEAR)
	menu.set_item_icon(menu.get_item_index(TextEdit.MENU_UNDO), ICON_UNDO)
	menu.set_item_icon(menu.get_item_index(TextEdit.MENU_REDO), ICON_REDO)
	
	# Add new items.
	if not is_window:
		menu.add_icon_item(ICON_WINDOW, "Window", MENU_WINDOW)


static func setup_text_edit(text_edit: TextEdit) -> void:
	# Hide scroll grabber.
	text_edit.get_v_scroll_bar().add_theme_stylebox_override("scroll", empty_style)
	text_edit.get_v_scroll_bar().add_theme_stylebox_override("scroll_focus", empty_style)
	text_edit.get_v_scroll_bar().add_theme_stylebox_override("grabber", empty_style)
	text_edit.get_v_scroll_bar().add_theme_stylebox_override("grabber_highlight", empty_style)
	text_edit.get_v_scroll_bar().add_theme_stylebox_override("grabber_pressed", empty_style)
	text_edit.get_h_scroll_bar().add_theme_stylebox_override("scroll", empty_style)
	text_edit.get_h_scroll_bar().add_theme_stylebox_override("scroll_focus", empty_style)
	text_edit.get_h_scroll_bar().add_theme_stylebox_override("grabber", empty_style)
	text_edit.get_h_scroll_bar().add_theme_stylebox_override("grabber_highlight", empty_style)
	text_edit.get_h_scroll_bar().add_theme_stylebox_override("grabber_pressed", empty_style)


static func setup_rich_text_label(rich_text_label: RichTextLabel) -> void:
	# Hide scroll grabber.
	rich_text_label.get_v_scroll_bar().add_theme_stylebox_override("scroll", empty_style)
	rich_text_label.get_v_scroll_bar().add_theme_stylebox_override("scroll_focus", empty_style)
	rich_text_label.get_v_scroll_bar().add_theme_stylebox_override("grabber", empty_style)
	rich_text_label.get_v_scroll_bar().add_theme_stylebox_override("grabber_highlight", empty_style)
	rich_text_label.get_v_scroll_bar().add_theme_stylebox_override("grabber_pressed", empty_style)
