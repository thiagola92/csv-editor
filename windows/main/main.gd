extends Panel


@onready var table_view: TableView = %TableView

@onready var about_window: Window = $AboutWindow

@onready var open_dialog: OpenDialog = $OpenDialog

@onready var save_dialog: SaveDialog = $SaveDialog

@onready var overwrite_dialog: OverwriteDialog = $OverwriteDialog

@onready var discard_dialog: DiscardDialog = $DiscardDialog


func _ready() -> void:
	var args: Dictionary = CLIHelper.parse()
	
	if args.get("file"):
		open_dialog._on_file_selected(args["file"])
	else:
		table_view.set_table_size(10, 10)
	
	UndoHelper.undo_redo.max_steps = 50


func _on_top_bar_about_requested() -> void:
	about_window.popup_centered()


func _on_top_bar_open_requested() -> void:
	open_dialog.popup_centered()


func _on_top_bar_quit_requested() -> void:
	if not FileHelper.current_file and UndoHelper.undo_redo.get_history_count():
		return discard_dialog.popup_centered()
	
	if FileHelper.was_modified():
		return discard_dialog.popup_centered()
	
	get_tree().quit()


func _on_top_bar_save_as_requested() -> void:
	save_dialog.popup_centered()


func _on_top_bar_save_requested() -> void:
	if not FileHelper.current_file:
		return save_dialog.popup_centered()
	
	if FileHelper.was_modified():
		return overwrite_dialog.popup_centered()
	
	FileHelper.set_content(table_view.get_table_values())


func _on_tree_exiting() -> void:
	UndoHelper.undo_redo.clear_history()
