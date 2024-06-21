extends TextureButton

const config_interface_scene = preload ("res://ConfigInterface/ConfigInterface.tscn")

func _ready():
	pressed.connect(Singleton.show_config_window)
	mouse_entered.connect(_on_mouse_entered)

func open_config_interface():
	var config_interface = config_interface_scene.instantiate()
	add_sibling(config_interface)
func _on_mouse_entered():
	show()
func _on_mouse_exited():
	if not ConfigHandler.current_config.always_show_hamburger:
		hide()
