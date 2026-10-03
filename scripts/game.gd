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
var init_margin: Vector2 = Vector2(0.2, 0.2)


func _ready() -> void:
	var plain_size: Vector2 = $ColorRect.size
	print("Plain Size:", plain_size)
	box_size = Vector2(175, 125)
	selector_scale = Vector2(1.2, 1.25)
	$Selector.size = box_size * selector_scale
	var cell_positions: Array[Vector2] = generate_grid_positions(plain_size, box_count_cells, box_size, init_margin)
	for box_position in cell_positions:
		print(box_position)
		var box1: Node2D = box_scene.instantiate()
		box1.setup("cells", box_position)
		boxes_cells.append(box1)
		$boxes.add_child(box1)
		cells.append(box_position)
	$Selector.position = cells[selector_pos.x * box_count_cells.y + selector_pos.y] - box_size * (selector_scale / 2)

	var cell_positions_compute: Array[Vector2] = generate_grid_positions(plain_size, box_count_compute, box_size / 4)
	for compute_box_position in cell_positions_compute:
		print(compute_box_position)
		var box2: Node2D = box_scene.instantiate()
		box2.setup("compute", compute_box_position, Vector2(75, 50), Vector2(1, 1))
		boxes_compute.append(box2)
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
		_box_count,
		_box_size: Vector2 = Vector2(175, 125),
		margin_ratio: Vector2 = Vector2(0.1, 0.1),
) -> Array[Vector2]:
	var positions: Array[Vector2]
	var _split_size = floor(_plain_size * (Vector2(1, 1) - 2 * margin_ratio) / _box_count)

	var margin: Vector2 = (_plain_size - _box_count * _split_size) / 2
	var span: Vector2 = floor((_plain_size - 2 * margin - _box_size) / (_box_count - Vector2(1, 1)))
	for i in range(_box_count.x):
		for j in range(_box_count.y):
			var box_pos: Vector2 = $ColorRect.position + margin + _box_size / 2 + span * Vector2(i, j)
			positions.append(box_pos)
			print("Box pos idx|", i, j, box_pos)
	return positions


# func _process(delta: float) -> void:
# 	print($boxes.get_child(0).get_child(0).color)
func draw_v_line(x_pos: float) -> void:
	var line = Line2D.new()
	line.add_point(Vector2(x_pos, -1000))
	line.add_point(Vector2(x_pos, 1000))
	line.default_color = Color.RED
	line.width = 2.0
	add_child(line)
