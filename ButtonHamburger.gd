extends TextureButton

const config_interface_scene = preload ("res://ConfigInterface/ConfigInterface.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(Singleton.show_config_window)

func open_config_interface():
	var config_interface = config_interface_scene.instantiate()
	add_sibling(config_interface)
