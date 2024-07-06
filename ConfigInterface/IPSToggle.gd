extends CheckButton

@onready
var ips_label = get_node("/root/Node2D/IPS")

func _ready():
	button_pressed = ConfigHandler.current_config.show_ips
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	ConfigHandler.current_config.show_ips = button_pressed

	if button_pressed:
		ips_label.change_to_alpha(1)
	else:
		ips_label.change_to_alpha(0)
