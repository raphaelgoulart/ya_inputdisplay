extends SpinBox

@onready
var scale_slider = get_node("/root/ConfigInterface/MainBackground/WindowScale/HSlider")

const MAX_WIDTH_NORMAL_SCALE = 50
var actual_value: float = MAX_WIDTH_NORMAL_SCALE
var actual_value_scale: float = 1 # the scale with which the actual_value was set.

func set_actual_value(new_actual_value: float = actual_value, new_scale: float = actual_value_scale):
	Singleton.print_verbose("set_actual_value(%f, %f)" % [new_actual_value, new_scale])
	actual_value = min(new_actual_value,self.max_value)
	actual_value_scale = new_scale
	_on_actual_value_changed()
	
func _on_actual_value_changed():
	Singleton.print_verbose("_on_actual_value_changed()")
	# self.set_value_no_signal(self.actual_value * self.actual_value_scale)
	self.set_value_no_signal(round(self.actual_value / self.actual_value_scale * ConfigHandler.current_config.window_scale))

func _ready():
	Singleton.config_interface_spinboxes.append(self)
	actual_value = ConfigHandler.current_config.input_bar_width
	actual_value_scale = ConfigHandler.current_config.window_scale
	value_changed.connect(_on_value_changed)
	scale_slider.value_changed.connect(_on_window_scale_changed)
	_on_window_scale_changed(scale_slider.value)

func _on_value_changed(_value: float, keep_actuval = false):
	Singleton.print_verbose("_on_value_changed(%f, %s)" % [_value, keep_actuval])
	if not keep_actuval:
		Singleton.print_verbose(value)
		self.set_actual_value(_value, ConfigHandler.current_config.window_scale)
	sky_print_verbose()
	ConfigHandler.current_config.input_bar_width = floor(value)

func _on_window_scale_changed(new_scale_value: float):
	Singleton.print_verbose("_on_window_scale_changed(%f)" % new_scale_value)
	sky_print_verbose(" (0)")
	if new_scale_value == self.actual_value_scale:
		self._set_max_value_keep_actual(MAX_WIDTH_NORMAL_SCALE * new_scale_value)
		sky_print_verbose(" (1a)")
		self._set_value_keep_actual(actual_value)
		sky_print_verbose(" (2a)")
	else:
		var new_value = floor(self.actual_value / self.actual_value_scale) * new_scale_value
		sky_print_verbose(" (1b)", new_value)
		self._set_max_value_keep_actual(MAX_WIDTH_NORMAL_SCALE * new_scale_value)
		sky_print_verbose(" (2b)", new_value)
		self.set_value_no_signal(new_value)
		sky_print_verbose(" (3b)", new_value)
	# self.set_actual_value(new_value, new_scale_value)
	_on_value_changed(self.value, true)

func _set_max_value_keep_actual(new_value: float):
	Singleton.print_verbose("_set_max_value_keep_actual(%f)" % new_value)
	var actual_val = actual_value
	var actual_val_scale = actual_value_scale
	self.max_value = new_value
	self.actual_value = actual_val
	self.actual_value_scale = actual_val_scale
func _set_value_keep_actual(new_value: float):
	Singleton.print_verbose("_set_value_keep_actual(%f)" % new_value)
	var actual_val = actual_value
	var actual_val_scale = actual_value_scale
	self.set_value_no_signal(new_value)
	_on_value_changed(new_value, true)
	self.actual_value = actual_val
	self.actual_value_scale = actual_val_scale

# this is exclusively for debugging purposes, I'll leave this code in just in case

func sky_print_verbose(extrathing = "", new_value=NAN):
	var formatted_values = "value: %f, max_value: %f, actual_value: %f, actual_value_scale: %f" % [value, max_value, actual_value, actual_value_scale]
	if not is_nan(new_value):
		formatted_values += (", new_value: %f" % new_value)
	formatted_values += extrathing
	Singleton.print_verbose(formatted_values)
