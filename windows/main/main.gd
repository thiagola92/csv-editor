extends Panel


@onready var table_view: TableView = %TableView

@onready var open_dialog: OpenDialog = $OpenDialog

@onready var save_dialog: SaveDialog = $SaveDialog

@onready var overwrite_dialog: OverwriteDialog = $OverwriteDialog


func _ready() -> void:
	open_dialog.table_view = table_view
	save_dialog.table_view = table_view


func _on_top_bar_open_requested() -> void:
	open_dialog.popup_centered()


func _on_top_bar_quit_requested() -> void:
	pass # Replace with function body.


func _on_top_bar_save_as_requested() -> void:
	save_dialog.popup_centered()


func _on_top_bar_save_requested() -> void:
	if not FileHelper.current_file:
		return _on_top_bar_save_as_requested()
	
	if FileHelper.was_modified():
		overwrite_dialog.popup_centered()
		
		var accepted = await overwrite_dialog.response
		
		if not accepted:
			return
	
	FileHelper.set_content(table_view.get_table_values())
