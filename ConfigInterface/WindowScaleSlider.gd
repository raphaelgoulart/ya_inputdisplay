extends HSlider

@onready
var value_label: Label = $ValueLabel

func _ready():
	value = ConfigHandler.current_config.window_scale
	update_label(value)
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float):
	ConfigHandler.current_config.window_scale = new_value
	Singleton.update_window_bounds()
	update_label(new_value)

func update_label(new_value: float):
	value_label.text = str(new_value) + "x"
