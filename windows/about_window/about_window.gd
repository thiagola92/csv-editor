extends Window


func _on_close_requested() -> void:
	hide()


func _on_visibility_changed() -> void:
	size = Vector2i(300, 200)
