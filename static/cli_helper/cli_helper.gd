class_name CLIHelper
extends RefCounted


static func parse() -> Dictionary:
	var args: Dictionary
	
	for arg in OS.get_cmdline_user_args():
		if arg.is_absolute_path() or arg.is_relative_path():
			args["file"] = arg
		
		# We only support one argument right now.
		break
	
	return args
