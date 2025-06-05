class_name CSVHelper
extends RefCounted


## Receives [param lines], an [Array] of [Array][lb][String][rb],
## and convert it to an CSV String. Which [String] is a value from the
## respective line.
## [br][br]
## If [param oneline] is true, only the first line will be converted.
static func to_csv(lines: Array[Array], oneline: bool = false) -> String:
	var file := FileAccess.create_temp(FileAccess.READ_WRITE, "csv-line", "csv")
	
	if not file:
		push_warning("Failed to open temp file (error %s)" % FileAccess.get_open_error())
		return ""
	
	for l in lines:
		file.store_csv_line(l)
		
		if oneline:
			break
	
	file.seek(0)
	
	var text: String = FileAccess.get_file_as_string(file.get_path())
	
	# Return without the newline at the end.
	return text.substr(0, text.length() - 1)


## Receives a [String] and convert it to an [Array] of [Array][lb][String][rb].
## [br][br]
## If [param oneline] is true, it will stop after finding one line.
static func from_text(text: String, oneline: bool = false) -> Array[Array]:
	var csv: Array[Array] = []
	var file := FileAccess.create_temp(FileAccess.READ_WRITE, "csv-line", "csv")
	
	if not file:
		push_warning("Failed to open temp file (error %s)" % FileAccess.get_open_error())
		return []
	
	file.store_string(text)
	file.seek(0)
	
	while !file.eof_reached():
		csv.append(Array(file.get_csv_line()))
		
		if oneline:
			break
	
	return csv
