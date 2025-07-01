class_name BigfileDialog
extends ConfirmationDialog


signal accepted(bool)


func _ready() -> void:
	get_ok_button().modulate = Color.html("#c64600")


func _on_canceled() -> void:
	accepted.emit(false)


func _on_confirmed() -> void:
	accepted.emit(true)
