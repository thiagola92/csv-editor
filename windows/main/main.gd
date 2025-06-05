extends Panel


@onready var table_view = %TableView

@onready var open_dialog: OpenDialog = $OpenDialog

@onready var save_dialog: SaveDialog = $SaveDialog

@onready var verification_dialog: VerificationDialog = $VerificationDialog


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
	
	verification_dialog.title = ""
	verification_dialog.dialog_text = ""
	verification_dialog.reset_size()
	verification_dialog.popup_centered()
	
	var confirmed = await verification_dialog.response
	
	if not confirmed:
		return
