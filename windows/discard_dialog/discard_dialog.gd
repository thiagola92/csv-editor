class_name DiscardDialog
extends ConfirmationDialog


@export var table_view: TableView


func _ready() -> void:
	get_ok_button().modulate = Color.html("#c64600")


func _on_confirmed() -> void:
	get_tree().quit()
