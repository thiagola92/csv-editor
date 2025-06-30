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

@export var table_view: TableView

@onready var row_columns: RowColumns = $RowColumns

@onready var rows: VBoxContainer = $Rows


func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_redo"):
		UndoHelper.undo_redo.redo()
	elif event.is_action_pressed("ui_undo"):
		UndoHelper.undo_redo.undo()


###############################################################
# Row methods (CORE)
# add_xxx, get_xxx, move_xxx, remove_xxx and their plural version.
###############################################################


func add_row(index: int, row_cells: RowCells = null) -> void:
	var columns_headers: Array[ColumnHeader] = row_columns.get_columns()
	var columns_count: int = columns_headers.size()
	var columns_width: Array[float] = row_columns.get_columns_width(0, columns_count)
	
	if row_cells:
		rows.add_child(row_cells)
		rows.move_child(row_cells, index)
		return
	
	row_cells = RowCellsScene.instantiate()
	row_cells.table = self
	
	rows.add_child(row_cells)
	rows.move_child(row_cells, index)
	row_cells.add_cells(0, columns_count)
	
	for i in columns_count:
		row_cells.set_cell_width(i, columns_width[i])
		row_cells.set_cell_control(i, columns_headers[i])


func get_row(index: int) -> RowCells:
	return rows.get_child(index) as RowCells


func get_rows() -> Array[RowCells]:
	var array: Array[RowCells]
	array.assign(rows.get_children())
	return array


func move_row(from: int, to: int) -> void:
	rows.move_child(get_row(from), to)


func remove_row(index: int) -> void:
	rows.remove_child(get_row(index))


###############################################################
# Row methods (UTILITY)
###############################################################


func clear_row(index: int) -> void:
	get_row(index).clear_cells()


func clear_rows() -> void:
	for r in get_rows():
		r.clear_cells()


func copy_rows() -> void:
	var lines: Array[Array] = get_rows_values()
	var text: String = CSVHelper.to_csv(lines)
	
	DisplayServer.clipboard_set(text)


## Find out the row index from a node.
func find_row_index(node: Node) -> int:
	while node is not RowCells:
		node = node.get_parent()
		
		if node == null:
			return -1
	
	return node.get_index()


## Focus a row header.[br]
## Used to make cells lose focus and store their state in UndoRedo.
func focus_row(index: int) -> void:
	get_row(index).row_header.grab_focus()


func get_row_values(index: int) -> Array[String]:
	return get_row(index).get_cells_values()


func get_rows_count() -> int:
	return rows.get_child_count()


## Get the rows that will be target if quantity change to [param]quantity[/parma].[br]
## Helps with undoing & redoing [method set_rows_quantity].
func get_rows_target(quantity: int) -> Array[RowCells]:
	var rows_count: int = get_rows_count()
	var diff: int = rows_count - quantity
	var target: Array[RowCells] = []
	
	if diff > 0:
		for i in range(quantity, rows_count):
			target.append(get_row(i))
	
	return target


func get_rows_values() -> Array[Array]:
	var lines: Array[Array] = []
	
	for r in get_rows():
		var l: Array
		l.assign(r.get_cells_values())
		lines.append(l)
	
	return lines


func paste_rows() -> void:
	var text: String = DisplayServer.clipboard_get()
	var lines: Array[Array] = CSVHelper.from_text(text)
	var values: Array[String]
	
	for i in min(lines.size(), get_rows_count()):
		values.assign(lines[i])
		set_row_values(i, values)


func set_row_values(index: int, values: Array[String]) -> void:
	get_row(index).set_cells_values(values)


func set_rows_values(values: Array[Array]) -> void:
	for i in min(values.size(), get_rows_count()):
		var l: Array[String]
		var r: RowCells = get_row(i)
		
		l.assign(values[i])
		r.set_cells_values(l)


## Set rows quantity to [param quantity].[br]
## When adding rows, will attempt to use [param using] if it size match 
## the [b]exactly[/b] difference in rows.
func set_rows_quantity(quantity: int, using: Array[RowCells] = []) -> void:
	var rows_count: int = get_rows_count()
	var diff: int = quantity - rows_count
	
	if diff > 0:
		if using.size() == diff:
			for r in using:
				add_row(-1, r)
		else:
			for i in diff:
				add_row(-1)
	elif diff < 0:
		for i in abs(diff):
			remove_row(-1)


func update_rows_label(start: int = 0) -> void:
	for i in range(start, get_rows_count()):
		get_row(i).update_header_label(i)
