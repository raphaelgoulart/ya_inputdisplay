extends CheckButton

func _ready():
	button_pressed = ConfigHandler.current_config.always_show_hamburger
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	ConfigHandler.current_config.always_show_hamburger = button_pressed
