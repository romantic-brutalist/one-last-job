extends Node2D

const BASE := Color("#23ee47")
const ALARM := Color("fc8151")
const STEP := 128.0 / 255.0 / 4.0

var cells: Array[ColorRect] = []


func _ready() -> void:
	return
	# $colorbox.color = Color("#23ee47")


func setup(_position: Vector2, _size: Vector2 = Vector2(175, 125), ib_count: Vector2 = Vector2(4, 4), _type: String = "cells") -> void:
	var ib_box_size: Vector2 = floor(_size / ib_count)
	var ib_initial_pos: Vector2 = -2 * ib_box_size
	var _color: Color
	if _type == "cells":
		_color = BASE
	elif _type == "alarm":
		_color = ALARM
	for i in range(ib_count.x):
		for j in range(ib_count.y):
			# print(i, j)
			var rect := ColorRect.new()
			rect.size = ib_box_size
			rect.position = ib_initial_pos + ib_box_size * Vector2(i, j)
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

	position = _position
	# $colorbox.size = _size
	# $colorbox.position = Vector2(0, 0)
	# $colorbox.position = Vector2(-0.5 * _size.x, -0.5 * _size.y)
