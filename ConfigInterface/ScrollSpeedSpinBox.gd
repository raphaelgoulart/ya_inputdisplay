extends SpinBox

func _ready():
	Singleton.config_interface_spinboxes.append(self)
	value = ConfigHandler.current_config.scroll_rate
	value_changed.connect(_on_value_changed)

func _on_value_changed(_value: float):
	ConfigHandler.current_config.scroll_rate = value
	ConfigHandler.current_config.scaled_scroll_rate = ConfigHandler.current_config.window_scale * value
