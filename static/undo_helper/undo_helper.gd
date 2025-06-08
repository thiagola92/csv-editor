class_name UndoHelper
extends RefCounted


static var undo_redo := UndoRedo.new()


static func print_actions() -> void:
	print("[ --- START HISTORY")
	
	for i in undo_redo.get_history_count():
		print("	%s" % undo_redo.get_action_name(i))
	
	print("]")
