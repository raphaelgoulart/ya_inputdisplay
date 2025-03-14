extends CheckButton

func _ready():
	button_pressed = ConfigHandler.current_config.waterfall_strums
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	ConfigHandler.current_config.set_waterfall_strums(button_pressed)
