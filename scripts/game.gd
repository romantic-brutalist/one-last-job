extends Node2D

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


func _ready() -> void:
	var plain_size: Vector2 = $ColorRect.size
	print("Plain Size:", plain_size)
	box_size = Vector2(175, 125)
	selector_scale = Vector2(1.2, 1.25)
	$Selector.size = box_size * selector_scale
	var cell_positions: Array[Vector2] = generate_grid_positions(plain_size, box_count_cells, box_size, init_margin)
	for box_position in cell_positions:
		# draw_box_borders(box_position - box_size / 2, box_size)
		print(box_position)
		var box1: Node2D = box_scene.instantiate()
		box1.setup("cells", box_position)
		boxes_cells.append(box1)
		$boxes.add_child(box1)
		cells.append(box_position)
	$Selector.position = cells[selector_pos.x * box_count_cells.y + selector_pos.y] - box_size * (selector_scale / 2)

	var cell_positions_compute: Array[Vector2] = generate_grid_positions(plain_size, box_count_compute, box_size / 4, Vector4(0.025, 0.175, 0.1, 0.9))
	for compute_box_position in cell_positions_compute:
		print(compute_box_position)
		# draw_box_borders(compute_box_position - box_size / 8, box_size / 4)
		var box2: Node2D = box_scene.instantiate()
		box2.setup("compute", compute_box_position, box_size / 4, Vector2(1, 1))
		boxes_compute.append(box2)
		$boxes.add_child(box2)

	var cell_positions_alarm: Array[Vector2] = generate_grid_positions(plain_size, box_count_alarm, box_size / 4, Vector4(0.825, 0.975, 0.1, 0.9))
	for alarm_box_position in cell_positions_alarm:
		print(alarm_box_position)
		# draw_box_borders(alarm_box_position - box_size / 8, box_size / 4)
		var box2: Node2D = box_scene.instantiate()
		box2.setup("alarm", alarm_box_position, box_size / 4, Vector2(1, 1))
		boxes_alarm.append(box2)
		$boxes.add_child(box2)

	print("BOX_COUNT:", box_count)


func _process(delta: float) -> void:
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


func draw_v_line(x_pos: float, color: Color = Color.RED) -> void:
	var line = Line2D.new()
	line.add_point(Vector2(x_pos, -1000))
	line.add_point(Vector2(x_pos, 1000))
	line.default_color = color
	line.width = 2.0
	add_child(line)


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


func draw_h_line(y_pos: float, color: Color = Color.RED) -> void:
	var line = Line2D.new()
	line.add_point(Vector2(-2000, y_pos))
	line.add_point(Vector2(2000, y_pos))
	line.default_color = color
	line.width = 2.0
	add_child(line)


func corner_pairs(a: Vector2, b: Vector2) -> Array[Vector2]:
	var out: Array[Vector2] = []
	for x in [a.x, b.x]:
		for y in [a.y, b.y]:
			out.append(Vector2(x, y))
	return out
