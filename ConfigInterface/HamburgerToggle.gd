extends CheckButton

@onready
var hamburger = Singleton.root_node.get_node("ButtonHamburger")

func _ready():
	button_pressed = ConfigHandler.current_config.always_show_hamburger
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	ConfigHandler.current_config.always_show_hamburger = button_pressed

	if button_pressed:
		hamburger.change_to_alpha(1)
	else:
		hamburger.change_to_alpha(0)
