class_name OverwriteDialog
extends ConfirmationDialog


signal response(confirmed: bool)


func _ready() -> void:
	get_ok_button().modulate = Color.html("#c64600")


func _on_canceled() -> void:
	response.emit(false)


func _on_confirmed() -> void:
	response.emit(true)
