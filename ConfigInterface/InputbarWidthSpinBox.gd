extends SpinBox

@onready
var scale_slider = get_node("/root/ConfigInterface/MainBackground/WindowScale/HSlider")

var actual_value: float = 40
var actual_value_scale: float = 1 # the scale with which the actual_value was set.

func set_actual_value(new_actual_value: float = actual_value, new_scale: float = actual_value_scale):
	actual_value = min(new_actual_value,self.max_value)
	actual_value_scale = new_scale
	_on_actual_value_changed()
	
func _on_actual_value_changed():
	# self.set_value_no_signal(self.actual_value * self.actual_value_scale)
	self.set_value_no_signal(round(self.actual_value / self.actual_value_scale * ConfigHandler.current_config.window_scale))

func _ready():
	Singleton.config_interface_spinboxes.append(self)
	actual_value = value
	value = ConfigHandler.current_config.input_bar_width
	value_changed.connect(_on_value_changed)
	scale_slider.value_changed.connect(_on_window_scale_changed)
	_on_window_scale_changed(scale_slider.value)

func _on_value_changed(_value: float, keep_actuval = false):
	sky_print(value)
	if not keep_actuval:
		self.set_actual_value(_value, ConfigHandler.current_config.window_scale)
	sky_print("value: %f, max_value: %f, actual_value: %f, actual_value_scale: %f" % [value, max_value, actual_value, actual_value_scale])
	ConfigHandler.current_config.input_bar_width = floor(value)

func _on_window_scale_changed(new_scale_value: float):
	sky_print("value: %f, max_value: %f, actual_value: %f, actual_value_scale: %f (0)" % [value, max_value, actual_value, actual_value_scale])
	if new_scale_value == self.actual_value_scale:
		self._set_max_value_keep_actual(40 * new_scale_value)
		sky_print("value: %f, max_value: %f, actual_value: %f, actual_value_scale: %f (1a)" % [value, max_value, actual_value, actual_value_scale])
		self._set_value_keep_actual(actual_value)
		sky_print("value: %f, max_value: %f, actual_value: %f, actual_value_scale: %f (2a)" % [value, max_value, actual_value, actual_value_scale])
	else:
		var new_value = floor(self.actual_value / self.actual_value_scale) * new_scale_value
		sky_print("value: %f, max_value: %f, actual_value: %f, actual_value_scale: %f, new_value: %f (1b)" % [value, max_value, actual_value, actual_value_scale, new_value])
		self._set_max_value_keep_actual(40 * new_scale_value)
		sky_print("value: %f, max_value: %f, actual_value: %f, actual_value_scale: %f, new_value: %f (2b)" % [value, max_value, actual_value, actual_value_scale, new_value])
		self.set_value_no_signal(new_value)
		sky_print("value: %f, max_value: %f, actual_value: %f, actual_value_scale: %f, new_value: %f (3b)" % [value, max_value, actual_value, actual_value_scale, new_value])
	# self.set_actual_value(new_value, new_scale_value)
	# _on_value_changed(self.value)

func _set_max_value_keep_actual(new_value: float):
	var actual_val = actual_value
	var actual_val_scale = actual_value_scale
	self.max_value = new_value
	self.actual_value = actual_val
	self.actual_value_scale = actual_val_scale
func _set_value_keep_actual(new_value: float):
	var actual_val = actual_value
	var actual_val_scale = actual_value_scale
	self.set_value_no_signal(new_value)
	_on_value_changed(new_value, true)
	self.actual_value = actual_val
	self.actual_value_scale = actual_val_scale

# this is for debugging purposes, I'll leave this code in just in case
const sky_debug = false
func sky_print(thing):
	if sky_debug:
		print(thing)
