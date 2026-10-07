extends Node2D

## Main scene: lays out three box grids ("cells", "compute", "alarm") on the
## screen, and moves a keyboard-driven selector across the cell grid.
##
## Current state: grid layout + selector movement work; interaction (space
## press) is stubbed.
var rng := RandomNumberGenerator.new()
var box_scene: PackedScene = preload("res://scenes/box.tscn")
var span_grid: bool = true
var cells: Array[Vector2] = []
var boxes_cells: Array[Node2D] = [] # use the root type of box.tscn (Node2D, Area2D, Sprite2D, etc.)
var boxes_compute: Array[Node2D] = [] # use the root type of box.tscn (Node2D, Area2D, Sprite2D, etc.)
var boxes_alarm: Array[Node2D] = [] # use the root type of box.tscn (Node2D, Area2D, Sprite2D, etc.)
var selector_pos: Vector2 = Vector2(0, 0)
var box_count: Vector2
var direction: Vector2
var box_size: Vector2
var selector_scale: Vector2
var box_count_cells: Vector2 = Vector2(4, 3)
var box_count_compute: Vector2 = Vector2(1, 10)
var box_count_alarm: Vector2 = Vector2(1, 10)
var init_margin: Vector4 = Vector4(0.2, 0.8, 0.2, 0.8)
var grid := PackedInt32Array()


## Instantiates every box, positions it via [method generate_grid_positions],
## and places the selector on the first cell.
func _ready() -> void:
	grid.resize(box_count_cells.x * box_count_cells.y)
	grid.fill(0)
	var grid_fill: int = 0
	for i in range(box_count_cells.x):
		for j in range(box_count_cells.y):
			var _prob: int = rng.randi_range(0, 99)
			if _prob < 20:
				grid_fill = 0
			elif _prob < 50:
				grid_fill = 1
			elif _prob < 85:
				grid_fill = 2
			else:
				grid_fill = 3

			grid[i * box_count_cells.y + j] = grid_fill
	#TODO: modularize ready function, move box spawns under generate grid function
	var plain_size: Vector2 = $ColorRect.size
	print("Plain Size:", plain_size)
	box_size = Vector2(175, 125)
	selector_scale = Vector2(1.2, 1.25)
	$Selector.size = box_size * selector_scale
	var cell_positions: Array[Vector2] = generate_grid_positions(plain_size, box_count_cells, box_size, init_margin)
	for i in cell_positions.size():
		var box_position: Vector2 = cell_positions[i]
		# draw_box_borders(box_position - box_size / 2, box_size)
		print(box_position)
		var box1: Node2D = box_scene.instantiate()
		box1.setup("cells", box_position, str(grid[i]))
		boxes_cells.append(box1)
		$boxes.add_child(box1)
		cells.append(box_position)
	$Selector.position = cells[selector_pos.x * box_count_cells.y + selector_pos.y] - box_size * (selector_scale / 2)

	var cell_positions_compute: Array[Vector2] = generate_grid_positions(plain_size, box_count_compute, box_size / 4, Vector4(0.025, 0.175, 0.2, 0.8))
	for i in cell_positions_compute.size():
		var compute_box_position = cell_positions_compute[i]
		if i == cell_positions_compute.size() - 1:
			var text_box_size: Vector2 = box_size / 2
			label_at_pos(compute_box_position + Vector2(-0.5 * text_box_size.x / 2, 2 * text_box_size.y), box_size / 4, "COMPUTE:10")
			# draw_box_borders(compute_box_position + Vector2(-0.5 * text_box_size.x / 2, 3 * text_box_size.y), box_size / 4)
		print(compute_box_position)
		# draw_box_borders(compute_box_position - box_size / 8, box_size / 4)
		var box2: Node2D = box_scene.instantiate()
		box2.setup("compute", compute_box_position, "", box_size / 4, Vector2(1, 1))
		boxes_compute.append(box2)
		$boxes.add_child(box2)

	var cell_positions_alarm: Array[Vector2] = generate_grid_positions(plain_size, box_count_alarm, box_size / 4, Vector4(0.825, 0.975, 0.2, 0.8))
	for i in cell_positions_alarm.size():
		var alarm_box_position = cell_positions_alarm[i]
		if i == cell_positions_compute.size() - 1:
			var text_box_size: Vector2 = box_size / 2
			label_at_pos(alarm_box_position + Vector2(-0.5 * text_box_size.x / 2, 2 * text_box_size.y), box_size / 4, "ALARM:10")
		print(alarm_box_position)
		# draw_box_borders(alarm_box_position - box_size / 8, box_size / 4)
		var box2: Node2D = box_scene.instantiate()
		box2.setup("alarm", alarm_box_position, "", box_size / 4, Vector2(1, 1))
		boxes_alarm.append(box2)
		$boxes.add_child(box2)

	print("BOX_COUNT:", box_count)


## Moves the selector with the left/right/up/down actions and recenters it on
## the current cell each frame. Space press/release is stubbed.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		selector_pos = (selector_pos + Vector2(-1, 0)).max(Vector2(0, 0))
		print(direction, "|", selector_pos)
	elif Input.is_action_just_pressed("right"):
		selector_pos = (selector_pos + Vector2(1, 0)).min(Vector2(box_count_cells.x - 1, box_count_cells.y - 1))
		print(direction, "|", selector_pos)
	elif Input.is_action_just_pressed("down"):
		selector_pos = (selector_pos + Vector2(0, 1)).min(Vector2(box_count_cells.x - 1, box_count_cells.y - 1))
		print(direction, "|", selector_pos)
	elif Input.is_action_just_pressed("up"):
		selector_pos = (selector_pos + Vector2(0, -1)).max(Vector2(0, 0))
		print(direction, "|", selector_pos)
	if Input.is_action_just_pressed("space"):
		print("something")
	if Input.is_action_just_released("space"):
		print("something")

	$Selector.position = cells[selector_pos.x * box_count_cells.y + selector_pos.y] - box_size * (selector_scale / 2)


## Returns the center positions of a `box_count` x `box_count` grid of boxes
## of the given size, spread between `margin_ratio` (left, right, top, bottom)
## of the screen. Boxes in an axis with a single box are centered in the span.
func generate_grid_positions(
		_plain_size: Vector2,
		_box_count: Vector2,
		_box_size: Vector2 = Vector2(175, 125),
		margin_ratio: Vector4 = Vector4(0.1, 0.9, 0.1, 0.9),
		verbose: bool = false,
) -> Array[Vector2]:
	#TODO: in the future if i switched to varying max box counts for the compute and alarm grids i should implement a snap to lrtb but keep span formatting
	var positions: Array[Vector2]

	var margin: Vector4 = Vector4(_plain_size.x, _plain_size.x, _plain_size.y, _plain_size.y) * margin_ratio
	if verbose:
		draw_v_line($ColorRect.position.x + margin.x)
		draw_v_line($ColorRect.position.x + margin.y)
		draw_h_line($ColorRect.position.y + margin.z)
		draw_h_line($ColorRect.position.y + margin.w)

	var span: Vector2 = (_plain_size * Vector2(margin_ratio.y - margin_ratio.x, margin_ratio.w - margin_ratio.z) - _box_size) / (_box_count - Vector2(1, 1)).max(Vector2(1, 1))
	var starting_span: Vector2 = Vector2(int(_box_count.x == 1), int(_box_count.y == 1)) * span / 2
	var grid_start: Vector2 = $ColorRect.position + Vector2(margin.x, margin.z) + _box_size / 2 + starting_span
	if verbose:
		print("BOX COUNT", _box_count)
		print("MARGIN:", margin)
		print("SPAN:", span)
		print("STARTiNG SPAN", Vector2(int(_box_count.x == 1), int(_box_count.y == 1)), Vector2(int(_box_count.x == 1), int(_box_count.y == 1)) * span / 2)
		draw_v_line(grid_start.x, Color.BLUE)
		draw_h_line(grid_start.y, Color.BLUE)
		print("GRID START:", $ColorRect.position + Vector2(margin.x, margin.z) + _box_size / 2)
	for i in range(_box_count.x):
		for j in range(_box_count.y):
			var box_pos: Vector2 = grid_start + span * Vector2(i, j)
			positions.append(box_pos)
			if verbose:
				print("Box pos idx|", i, j, box_pos)
	return positions


## Debug: draws a full-height vertical line at `x_pos` in scene coordinates.
func draw_v_line(x_pos: float, color: Color = Color.RED) -> void:
	var line = Line2D.new()
	line.add_point(Vector2(x_pos, -1000))
	line.add_point(Vector2(x_pos, 1000))
	line.default_color = color
	line.width = 2.0
	add_child(line)


## Debug: draws a rectangle border at `_pos` with the given `_size`.
func draw_box_borders(_pos: Vector2, _size: Vector2) -> void:
	var bottom_right: Vector2 = _pos + _size
	var corners: Array[Vector2] = corner_pairs(_pos, bottom_right)
	for i in range(4):
		var corner1 = corners[i % 4]
		var corner2 = corners[(i + 1) % 4]
		var line = Line2D.new()
		line.add_point(corner1)
		line.add_point(corner2)
		line.default_color = Color.YELLOW
		line.width = 2.0
		add_child(line)


## Debug: draws a full-width horizontal line at `y_pos` in scene coordinates.
func draw_h_line(y_pos: float, color: Color = Color.RED) -> void:
	var line = Line2D.new()
	line.add_point(Vector2(-2000, y_pos))
	line.add_point(Vector2(2000, y_pos))
	line.default_color = color
	line.width = 2.0
	add_child(line)


## Debug: returns the 4 corners of the rect from `a` (top-left) to `b` (bottom-right).
func corner_pairs(a: Vector2, b: Vector2) -> Array[Vector2]:
	var out: Array[Vector2] = []
	for x in [a.x, b.x]:
		for y in [a.y, b.y]:
			out.append(Vector2(x, y))
	return out


func label_at_pos(_pos: Vector2, _size: Vector2, _text: String) -> void:
	var text_label := Label.new()
	text_label.position = _pos
	text_label.text = _text
	text_label.add_theme_color_override("font_color", Color.WHITE)
	text_label.add_theme_font_size_override("font_size", 20)
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(text_label)
	text_label.size = text_label.get_minimum_size()
	text_label.position = _pos + _size / 2.0 - text_label.size / 2.0
	print("TEXT LABEL DEBUG|", "POS:", text_label.position, "SIZE:", text_label.size, "SIZE INIT:", _size)
