extends Label
## Debug: shows the cursor position with the center of the ColorRect "screen" as (0, 0).

@onready var _screen: ColorRect = $"../ColorRect"

func _process(_delta: float) -> void:
	var center: Vector2 = _screen.global_position + _screen.size / 2.0
	var rel: Vector2 = (get_global_mouse_position() - center).floor()
	text = "x: %d  y: %d" % [rel.x, rel.y]
