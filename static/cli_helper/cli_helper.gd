class_name CLIHelper
extends RefCounted


static func parse() -> Dictionary:
	var args: Dictionary
	
	for arg in OS.get_cmdline_args():
		args["file"] = arg
		
		# We only support one argument right now.
		break
	
	return args
