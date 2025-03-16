extends CheckButton

@onready
var ips_label = get_node("/root/Node2D/IPS")

func _ready():
	button_pressed = ConfigHandler.current_config.borderless
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	ConfigHandler.current_config.borderless = button_pressed
	Singleton.update_window_border(button_pressed)
