## Holds all rows and take care of interactions between them.
##
## [codeblock]
## | empty | column 0 | column 1 | column 2 | ... | column X |
## | ------------------------------------------------------- |
## | row 0 | cell 0   | cell 1   | cell 2   | ... | cell X   |
## | ------------------------------------------------------- |
## | row 1 | cell 0   | cell 1   | cell 2   | ... | cell X   |
## | ------------------------------------------------------- |
## | row 2 | cell 0   | cell 1   | cell 2   | ... | cell X   |
## | ------------------------------------------------------- |
## [/codeblock]
class_name Table
extends VBoxContainer


const RowCellsScene: PackedScene = preload("row_cells/row_cells.tscn")

@onready var row_columns: RowColumns = $RowColumns

@onready var rows: VBoxContainer = $Rows


###############################################################
# Row methods (CORE)
# add_xxx, get_xxx, move_xxx, remove_xxx and their plural version.
###############################################################


func add_row(index: int) -> void:
	var row_cells: RowCells = RowCellsScene.instantiate()
	var columns_count: int = row_columns.get_columns_count()
	var columns_width: Array[float] = row_columns.get_columns_width(0, columns_count)
	
	row_cells.table = self
	
	rows.add_child(row_cells)
	rows.move_child(row_cells, index)
	row_cells.add_cells(0, columns_count)
	
	for i in columns_count:
		row_cells.set_cell_width(i, columns_width[i])


func get_row(index: int) -> RowCells:
	return rows.get_child(index) as RowCells


func get_rows() -> Array[RowCells]:
	var array: Array[RowCells]
	array.assign(rows.get_children())
	return array


func move_row(from: int, to: int) -> void:
	rows.move_child(get_row(from), to)


func remove_row(index: int) -> void:
	get_row(index).queue_free()


###############################################################
# Row methods (UTILITY)
###############################################################


func get_rows_count() -> int:
	return rows.get_child_count()


func clear_row(index: int) -> void:
	get_row(index).clear_cells()


func clear_rows() -> void:
	for r in get_rows():
		r.clear_cells()


func copy_rows() -> void:
	var lines: Array[Array] = []
	
	for r in get_rows():
		var l: Array[String] = []
		
		for c in r.get_cells():
			l.append(c.get_text())
		
		lines.append(l)
	
	var text: String = CSVHelper.to_csv(lines)
	
	DisplayServer.clipboard_set(text)


func paste_rows() -> void:
	var text: String = DisplayServer.clipboard_get()
	var lines: Array[Array] = CSVHelper.from_text(text)
	
	for i in min(lines.size(), get_rows_count()):
		var l: Array = lines[i]
		var r: RowCells = get_row(i)
		
		for j in min(l.size(), r.get_cells_count()):
			r.get_cell(j).set_text(l[j])


func update_rows_label(start: int = 0) -> void:
	for i in range(start, get_rows_count()):
		get_row(i).update_header_label(i)
