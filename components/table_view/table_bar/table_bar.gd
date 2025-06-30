class_name TableBar
extends HBoxContainer


@export var table_view: TableView

@onready var columns_counter: SpinBox = $ColumnsCounter

@onready var rows_counter: SpinBox = $RowsCounter

@onready var resize_dialog: ResizeDialog = $ResizeDialog


func _ready() -> void:
	rows_counter.get_line_edit().focus_exited.connect(_on_line_edit_focus_exited)
	rows_counter.get_line_edit().text_submitted.connect(_on_line_edit_focus_exited.unbind(1))
	columns_counter.get_line_edit().focus_exited.connect(_on_line_edit_focus_exited)
	columns_counter.get_line_edit().text_submitted.connect(_on_line_edit_focus_exited.unbind(1))


func set_row_counter(rows_count: int) -> void:
	rows_counter.value = rows_count


func set_column_counter(columns_count: int) -> void:
	columns_counter.value = columns_count


func _on_line_edit_focus_exited() -> void:
	if not table_view:
		return
	
	await get_tree().create_timer(0.1).timeout
	
	var current_rows: int = table_view.table.get_rows_count()
	var current_columns: int = table_view.table.row_columns.get_columns_count()
	var new_rows: int = int(rows_counter.value)
	var new_columns: int = int(columns_counter.value)
	
	if new_rows == current_rows and new_columns == current_columns:
		# Nothing to do.
		return
	
	if new_rows < current_rows or new_columns < current_columns:
		# Wait confirmation that can delete rows/columns.
		return resize_dialog.popup_centered()
	
	# Don't need confirmation to add rows/columns.
	_on_resize_dialog_confirmed()


func _on_resize_dialog_confirmed() -> void:
	var current_rows: int = table_view.table.get_rows_count()
	var current_columns: int = table_view.table.row_columns.get_columns_count()
	var new_rows: int = int(rows_counter.value)
	var new_columns: int = int(columns_counter.value)
	var targets: TableView.TableTargets = table_view.get_table_targets(new_rows, new_columns)
	
	UndoHelper.undo_redo.create_action("Resize table")
	
	for c in targets.columns:
		UndoHelper.undo_redo.add_undo_reference(c)
	
	for a in targets.cells:
		for c in a:
			UndoHelper.undo_redo.add_undo_reference(c)
	
	for r in targets.rows:
		UndoHelper.undo_redo.add_undo_reference(r)
	
	UndoHelper.undo_redo.add_do_property(rows_counter, "value", new_rows)
	UndoHelper.undo_redo.add_do_property(columns_counter, "value", new_columns)
	UndoHelper.undo_redo.add_do_method(table_view.set_table_size.bind(new_rows, new_columns))
	UndoHelper.undo_redo.add_undo_property(rows_counter, "value", current_rows)
	UndoHelper.undo_redo.add_undo_property(columns_counter, "value", current_columns)
	UndoHelper.undo_redo.add_undo_method(table_view.set_table_size.bind(current_rows, current_columns, targets))
	UndoHelper.undo_redo.commit_action()
