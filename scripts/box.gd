extends Node2D
## A box on the game screen: a grid of inner ColorRect "cells" with index
## labels, tinted by type ("cells" green, "compute" orange, "alarm" red).

const BASE := Color("#23ee47")
const COMPUTE := Color("fc8151")
const ALARM := Color.RED
const STEP := 128.0 / 255.0 / 4.0

var cells: Array[ColorRect] = []


func _ready() -> void:
	return
	# $colorbox.color = Color("#23ee47")


## Builds and lays out the inner cells, then centers the box at `_position`.
func setup(_type: String, _position: Vector2, _label: String = "", _size: Vector2 = Vector2(175, 125), ib_count: Vector2 = Vector2(4, 4)) -> void:
	# Here _size is the size of the outerbox, inner box sizer are calculated within the function
	var ib_box_size: Vector2 = floor(_size / ib_count)
	var ib_initial_pos: Vector2 = -1 * (ib_count / 2) * ib_box_size
	var _color: Color
	if _type == "cells":
		_color = BASE
	elif _type == "compute":
		_color = COMPUTE
	elif _type == "alarm":
		_color = ALARM

	for i in range(ib_count.x):
		for j in range(ib_count.y):
			# print(i, j)
			var rect := ColorRect.new()
			rect.size = ib_box_size
			rect.position = ib_initial_pos + ib_box_size * Vector2(i, j)
			if _type == "compute":
				print("INITIAL_POS", ib_initial_pos)
			rect.color = Color(_color.r + STEP * i, _color.g, _color.b + STEP * j)
			# print(rect.color)

			var label := Label.new()
			label.text = str(i) + str(j)
			label.size = ib_box_size
			label.add_theme_color_override("font_color", Color.BLACK)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			rect.add_child(label)

			add_child(rect)
			cells.append(rect)
	if _label != "":
		var text_label := Label.new()
		text_label.position = Vector2(-0.5 * ib_box_size.x, 2.5 * ib_box_size.y)
		text_label.text = "[ X ]"
		text_label.size = ib_box_size
		text_label.add_theme_color_override("font_color", Color.WHITE)
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		add_child(text_label)
		draw_box_borders(text_label.position, ib_box_size)

	position = _position
	# $colorbox.size = _size
	# $colorbox.position = Vector2(0, 0)
	# $colorbox.position = Vector2(-0.5 * _size.x, -0.5 * _size.y)


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


## Debug: returns the 4 corners of the rect from `a` (top-left) to `b` (bottom-right).
func corner_pairs(a: Vector2, b: Vector2) -> Array[Vector2]:
	var out: Array[Vector2] = []
	for x in [a.x, b.x]:
		for y in [a.y, b.y]:
			out.append(Vector2(x, y))
	return out
