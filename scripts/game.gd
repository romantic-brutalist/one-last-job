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


func _ready() -> void:
	var plain_size: Vector2 = $ColorRect.size
	var split_size: Vector2 = Vector2(400, 300)
	box_size = Vector2(175, 125)
	selector_scale = Vector2(1.2, 1.25)
	$Selector.size = box_size * selector_scale

	box_count = floor(plain_size * 0.8 / split_size)
	var margin: Vector2 = (plain_size - box_count * split_size) / 2
	var span: Vector2 = floor((plain_size - 2 * margin - box_size) / (box_count - Vector2(1, 1)))

	draw_v_line($ColorRect.position.x + margin.x)
	draw_v_line($ColorRect.position.x + $ColorRect.size.x - margin.x)
	for i in range(box_count.x):
		for j in range(box_count.y):
			var box1: Node2D = box_scene.instantiate()
			var box_pos: Vector2 = $ColorRect.position + margin + box_size / 2 + span * Vector2(i, j)
			box1.setup(box_pos)
			boxes_cells.append(box1)
			$boxes.add_child(box1)
			cells.append(box_pos)
	$Selector.position = cells[selector_pos.x * box_count.y + selector_pos.y] - box_size * (selector_scale / 2)
	print("BOX_COUNT:", box_count)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		selector_pos = (selector_pos + Vector2(-1, 0)).max(Vector2(0, 0))
		print(direction, "|", selector_pos)
	elif Input.is_action_just_pressed("right"):
		selector_pos = (selector_pos + Vector2(1, 0)).min(Vector2(box_count.x - 1, box_count.y - 1))
		print(direction, "|", selector_pos)
	elif Input.is_action_just_pressed("down"):
		selector_pos = (selector_pos + Vector2(0, 1)).min(Vector2(box_count.x - 1, box_count.y - 1))
		print(direction, "|", selector_pos)
	elif Input.is_action_just_pressed("up"):
		selector_pos = (selector_pos + Vector2(0, -1)).max(Vector2(0, 0))
		print(direction, "|", selector_pos)
	if Input.is_action_just_pressed("space"):
		print("something")
	if Input.is_action_just_released("space"):
		print("something")

	$Selector.position = cells[selector_pos.x * box_count.y + selector_pos.y] - box_size * (selector_scale / 2)


func generate_grid_positions(
		_plain_size: Vector2,
		box_count: Vector2,
		_split_size: Vector2 = Vector2(400, 300),
		margin_ratio: Vector2 = Vector2(0.1, 0.1),
) -> Array[Vector2]:
	return [Vector2(1, 1)]


# func _process(delta: float) -> void:
# 	print($boxes.get_child(0).get_child(0).color)
func draw_v_line(x_pos: float) -> void:
	var line = Line2D.new()
	line.add_point(Vector2(x_pos, -1000))
	line.add_point(Vector2(x_pos, 1000))
	line.default_color = Color.RED
	line.width = 2.0
	add_child(line)
