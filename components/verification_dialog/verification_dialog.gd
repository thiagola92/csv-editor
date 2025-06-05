class_name VerificationDialog
extends ConfirmationDialog


signal response(confirmed: bool)


func _on_canceled() -> void:
	response.emit(false)


func _on_confirmed() -> void:
	response.emit(true)
