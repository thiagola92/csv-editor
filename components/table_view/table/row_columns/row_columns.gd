## Represent the row with all columns headers.
## 
## [codeblock]
## | empty | column 0 | column 1 | column 2 | ... | column X |
## | ---------------------- separator ----------------------- |
## [/codeblock]
## [br]
## - empty: [EmptyHeader][br]
## - column: [ColumnHeader][br]
## - separator: [RowSeparator][br]
## [br]
## [b]Note:[/b] Almost the same as [RowCells] but using [ColumnHeader] instead of [Cell].
class_name RowColumns
extends VBoxContainer


const ColumnHeaderScene: PackedScene = preload("../column_header/column_header.tscn")

@export var table: Table

@onready var empty_header: EmptyHeader = %EmptyHeader

@onready var columns: HBoxContainer = %Columns


###############################################################
# EmptyHeader methods
###############################################################


func set_header_width(x: float) -> void:
	# Update size too because RowCells will use it
	# to set their custom_minimum_size.
	empty_header.size.x = x
	empty_header.custom_minimum_size.x = x


###############################################################
# Column methods (CORE)
# add_xxx, get_xxx, move_xxx, remove_xxx and their plural version.
###############################################################


func add_column(index: int, column_header: ColumnHeader = null) -> void:
	if column_header:
		columns.add_child(column_header)
		columns.move_child(column_header, index)
		return
	
	column_header = ColumnHeaderScene.instantiate()
	
	columns.add_child(column_header)
	columns.move_child(column_header, index)
	
	column_header.add_after_requested.connect(_on_column_header_add_after_requested)
	column_header.add_before_requested.connect(_on_column_header_add_before_requested)
	column_header.clear_requested.connect(_on_column_header_clear_requested)
	column_header.copy_requested.connect(_on_column_header_copy_requested)
	column_header.cut_requested.connect(_on_column_header_cut_requested)
	column_header.delete_requested.connect(_on_column_header_delete_requested)
	column_header.paste_requested.connect(_on_column_header_paste_requested)
	column_header.move_requested.connect(_on_column_header_move_requested)
	column_header.minimum_size_changed.connect(
		_on_column_header_minimum_size_changed.bind(column_header))


func get_column(index: int) -> ColumnHeader:
	return columns.get_child(index) as ColumnHeader


func get_columns() -> Array[ColumnHeader]:
	var array: Array[ColumnHeader]
	array.assign(columns.get_children())
	return array


func move_column(from: int, to: int) -> void:
	columns.move_child(get_column(from), to)


func remove_column(index: int) -> void:
	columns.remove_child(get_column(index))


###############################################################
# Column methods (UTILITY)
###############################################################


func get_column_width(index: int) -> float:
	return get_column(index).size.x # NOTE: Not the custom_minimum_size.


func get_column_values(index: int) -> Array[String]:
	if not table:
		return []
	
	var values: Array[String]
	
	for r in table.get_rows():
		values.append(r.get_cell_value(index))
	
	return values


func get_columns_count() -> int:
	return columns.get_child_count()


func get_columns_width(start: int, end: int) -> Array[float]:
	var widths: Array[float] = []
	
	for i in range(start, end):
		widths.append(get_column(i).size.x) # NOTE: Not the custom_minimum_size.
		
	return widths


func set_column_values(index: int, values: Array[String]) -> void:
	if not table:
		return
	
	for i in min(values.size(), table.get_rows_count()):
		table.get_row(i).set_cell_value(index, values[i])


func update_columns_label(start: int = 0) -> void:
	for i in range(start, get_columns_count()):
		get_column(i).update_label(i)


###############################################################
# EmptyHeader signals
###############################################################


func _on_empty_header_add_column_requested() -> void:
	var index: int = get_columns_count()
	
	add_column(index)
	update_columns_label(index)
	
	if not table:
		return
	
	var width: float = get_column_width(index)
	var new_column: ColumnHeader = get_column(index)
	var new_cells: Array[Cell]
	
	for r in table.get_rows():
		r.add_cell(index)
		r.set_cell_width(index, width)
		new_cells.append(r.get_cell(index))
	
	UndoHelper.undo_redo.create_action("Add column")
	UndoHelper.undo_redo.add_do_method(add_column.bind(index, new_column))
	UndoHelper.undo_redo.add_do_method(update_columns_label.bind(index))
	UndoHelper.undo_redo.add_do_reference(new_column)
	
	for i in min(new_cells.size(), table.get_rows_count()):
		var r: RowCells = table.get_row(i)
		var c: Cell = new_cells[i]
		
		UndoHelper.undo_redo.add_do_method(r.add_cell.bind(index, c))
		UndoHelper.undo_redo.add_do_reference(c)
		UndoHelper.undo_redo.add_undo_method(r.remove_cell.bind(index))
	
	UndoHelper.undo_redo.add_undo_method(remove_column.bind(index))
	UndoHelper.undo_redo.add_undo_method(update_columns_label.bind(index))
	UndoHelper.undo_redo.commit_action(false)


func _on_empty_header_add_row_requested() -> void:
	if not table:
		return
	
	var index: int = table.get_rows_count()
	
	table.add_row(index)
	table.update_rows_label(index)
	
	var new_row: RowCells = table.get_row(index)
	
	UndoHelper.undo_redo.create_action("Add row")
	UndoHelper.undo_redo.add_do_method(table.add_row.bind(index, new_row))
	UndoHelper.undo_redo.add_do_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.add_do_reference(new_row)
	UndoHelper.undo_redo.add_undo_method(table.remove_row.bind(index))
	UndoHelper.undo_redo.add_undo_method(table.update_rows_label.bind(index))
	UndoHelper.undo_redo.commit_action(false)


func _on_empty_header_clear_requested() -> void:
	if not table:
		return
	
	UndoHelper.undo_redo.create_action("Clear table")
	
	for r in table.get_rows():
		for c in r.get_cells():
			UndoHelper.undo_redo.add_do_method(c.clear)
			UndoHelper.undo_redo.add_undo_method(c.set_text.bind(c.get_text()))

	UndoHelper.undo_redo.commit_action()

func _on_empty_header_copy_requested() -> void:
	if not table:
		return
	
	table.copy_rows()


func _on_empty_header_cut_requested() -> void:
	_on_empty_header_copy_requested()
	_on_empty_header_clear_requested()


func _on_empty_header_paste_requested() -> void:
	if not table:
		return
	
	table.paste_rows()


func _on_empty_header_minimum_size_changed() -> void:
	if not table:
		return
	
	var width: float = empty_header.size.x # NOTE: Not the custom_minimum_size.

	for r in table.get_rows():
		r.set_header_width(width)


func _on_empty_header_redo_requested() -> void:
	UndoHelper.undo_redo.redo()


func _on_empty_header_undo_requested() -> void:
	UndoHelper.undo_redo.undo()


###############################################################
# ColumnHeader signals
###############################################################


func _on_column_header_add_after_requested(index: int) -> void:
	index += 1
	
	add_column(index)
	update_columns_label(index)
	
	if not table:
		return
	
	var width: float = get_column_width(index)
	var new_column: ColumnHeader = get_column(index)
	var new_cells: Array[Cell]
	
	for r in table.get_rows():
		r.add_cell(index)
		r.set_cell_width(index, width)
		new_cells.append(r.get_cell(index))
	
	UndoHelper.undo_redo.create_action("Add column after")
	UndoHelper.undo_redo.add_do_method(add_column.bind(index, new_column))
	UndoHelper.undo_redo.add_do_method(update_columns_label.bind(index))
	UndoHelper.undo_redo.add_do_reference(new_column)
	
	for i in min(new_cells.size(), table.get_rows_count()):
		var r: RowCells = table.get_row(i)
		var c: Cell = new_cells[i]
		
		UndoHelper.undo_redo.add_do_method(r.add_cell.bind(index, c))
		UndoHelper.undo_redo.add_do_reference(c)
		UndoHelper.undo_redo.add_undo_method(r.remove_cell.bind(index))
	
	UndoHelper.undo_redo.add_undo_method(remove_column.bind(index))
	UndoHelper.undo_redo.add_undo_method(update_columns_label.bind(index))
	UndoHelper.undo_redo.commit_action(false)


func _on_column_header_add_before_requested(index: int) -> void:
	add_column(index)
	update_columns_label(index)
	
	if not table:
		return
	
	var width: float = get_column_width(index)
	var new_column: ColumnHeader = get_column(index)
	var new_cells: Array[Cell]
	
	for r in table.get_rows():
		r.add_cell(index)
		r.set_cell_width(index, width)
		new_cells.append(r.get_cell(index))
	
	UndoHelper.undo_redo.create_action("Add column before")
	UndoHelper.undo_redo.add_do_method(add_column.bind(index, new_column))
	UndoHelper.undo_redo.add_do_method(update_columns_label.bind(index))
	UndoHelper.undo_redo.add_do_reference(new_column)
	
	for i in min(new_cells.size(), table.get_rows_count()):
		var r: RowCells = table.get_row(i)
		var c: Cell = new_cells[i]
		
		UndoHelper.undo_redo.add_do_method(r.add_cell.bind(index, c))
		UndoHelper.undo_redo.add_do_reference(c)
		UndoHelper.undo_redo.add_undo_method(r.remove_cell.bind(index))
	
	UndoHelper.undo_redo.add_undo_method(remove_column.bind(index))
	UndoHelper.undo_redo.add_undo_method(update_columns_label.bind(index))
	UndoHelper.undo_redo.commit_action(false)


func _on_column_header_clear_requested(index: int) -> void:
	if not table:
		return
	
	UndoHelper.undo_redo.create_action("Clear column")
	
	for r in table.get_rows():
		var value: String = r.get_cell_value(index)
		
		UndoHelper.undo_redo.add_do_method(r.clear_cell.bind(index))
		UndoHelper.undo_redo.add_undo_method(r.set_cell_value.bind(index, value))
	
	UndoHelper.undo_redo.commit_action()


func _on_column_header_copy_requested(index: int) -> void:
	if not table:
		return
	
	var lines: Array[Array] = []
	
	for r in table.get_rows():
		lines.append([r.get_cell_value(index)])
	
	var text: String = CSVHelper.to_csv(lines)
	
	DisplayServer.clipboard_set(text)


func _on_column_header_cut_requested(index: int) -> void:
	_on_column_header_copy_requested(index)
	_on_column_header_clear_requested(index)


func _on_column_header_delete_requested(index: int) -> void:
	if not table:
		return
	
	var column_header: ColumnHeader = get_column(index)
	
	UndoHelper.undo_redo.create_action("Remove column")
	UndoHelper.undo_redo.add_do_method(remove_column.bind(index))
	
	for r in table.get_rows():
		var c: Cell = r.get_cell(index)
		
		UndoHelper.undo_redo.add_do_method(r.remove_cell.bind(index))
		UndoHelper.undo_redo.add_undo_reference(c)
		UndoHelper.undo_redo.add_undo_method(r.add_cell.bind(index, c))
	
	UndoHelper.undo_redo.add_undo_reference(column_header)
	UndoHelper.undo_redo.add_undo_method(add_column.bind(index, column_header))
	UndoHelper.undo_redo.commit_action()


func _on_column_header_paste_requested(index: int) -> void:
	if not table:
		return
	
	var text: String = DisplayServer.clipboard_get()
	var lines: Array[Array] = CSVHelper.from_text(text)
	
	UndoHelper.undo_redo.create_action("Paste column")
	
	for i in min(lines.size(), table.get_rows_count()):
		var l: Array = lines[i]
		var r: RowCells = table.get_row(i)
		var v: String = r.get_cell_value(index)
		
		# User could have an empty line.
		if l.is_empty():
			continue
		
		UndoHelper.undo_redo.add_do_method(r.set_cell_value.bind(index, l[0]))
		UndoHelper.undo_redo.add_undo_method(r.set_cell_value.bind(index, v))
	
	UndoHelper.undo_redo.commit_action()


func _on_column_header_move_requested(from: int, to: int) -> void:
	var min_index: int = min(from, to)
	
	UndoHelper.undo_redo.create_action("Move column")
	UndoHelper.undo_redo.add_do_method(move_column.bind(from, to))
	UndoHelper.undo_redo.add_do_method(update_columns_label.bind(min_index))
	UndoHelper.undo_redo.add_undo_method(move_column.bind(to, from))
	UndoHelper.undo_redo.add_undo_method(update_columns_label.bind(min_index))
	
	if not table:
		return UndoHelper.undo_redo.commit_action()
	
	for r in table.get_rows():
		UndoHelper.undo_redo.add_do_method(r.move_cell.bind(from, to))
		UndoHelper.undo_redo.add_undo_method(r.move_cell.bind(to, from))
	
	UndoHelper.undo_redo.commit_action()


func _on_column_header_minimum_size_changed(column_header: ColumnHeader) -> void:
	if not table:
		return
	
	var index: int = column_header.get_index()
	var width: float = get_column_width(index)
	
	for r in table.get_rows():
		r.set_cell_width(index, width)
