# Container that clip children content.
# 
# This exist because:
#	- Anchoring to all sizes and puting inside a Control, make labels
#	centralized when resizing cells.
#	- Most containers force a fix size or add a scroll bar,
#	we don't want neither.
#
# So the solution is let the children use whatever anchor it wants
# (in case of cells would be top-left) and we resize they to fit this "container".
class_name ClipContainer
extends Control


func _on_item_rect_changed() -> void:
	for c in get_children():
		c.size = size
