extends ColorRect
## Test scene: assigns myshader.gdshader to this ColorRect at runtime.

func _ready() -> void:
	var mat := ShaderMaterial.new()                                  # create the material
	mat.shader = load("res://shaders/myshader.gdshader")            # give it your shader
	mat.set_shader_parameter("u_resolution", size)              # set a uniform on it
	material = mat    
