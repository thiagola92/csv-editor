extends Panel


@onready var table_view = %TableView

@onready var open_dialog: OpenDialog = %OpenDialog

@onready var save_dialog: SaveDialog = %SaveDialog


func _ready() -> void:
	open_dialog.table_view = table_view
	save_dialog.table_view = table_view


func _on_top_bar_open_requested() -> void:
	open_dialog.popup_centered()


func _on_top_bar_save_as_requested() -> void:
	save_dialog.popup_centered()


func _on_top_bar_save_requested() -> void:
	pass # Replace with function body.
