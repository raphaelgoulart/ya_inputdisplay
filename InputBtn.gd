extends Area2D

const inputbar = preload ("res://InputBar.tscn")
const Binding = preload ("res://Binding.gd")
var binding: Binding
signal released

var label
var center
var color
var count = 0
var max_alpha = 0.5
var fade_rate = 4
var spawn_inputbar = true
var length_label
var length = 0
var timestamp
var insideArea = false
var mapping = false
var index
var default_font_size = 31
var pressed = false
var is_wide = false
var true_index

const banned_keycodes = [KEY_MINUS, KEY_PLUS, KEY_EQUAL, KEY_COMMA, KEY_BRACKETLEFT, KEY_PERIOD, KEY_BRACKETRIGHT, KEY_BACKSPACE, KEY_ESCAPE]

# This is kept track of to detect duplicate inputs.
var gp_previous_framecount = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	true_index = get_meta("index")
	is_wide = name.ends_with("_wide") # this is basically just spawn_inputbar
	index = (true_index-2) if is_wide else true_index
	# bindings
	set_binding(ConfigHandler.load_binding(as_waterfall()))
	if not is_wide:
		add_child(binding)
	ConfigHandler.current_config.waterfall_strums_toggled.connect(_on_waterfall_strums_toggled)
	# colors and visual stuff
	center = $Center
	colorize(ConfigHandler.current_config.colors[index])
	spawn_inputbar = get_meta("inputbar")
	label = $VBoxContainer/Label
	length_label = $Length
	if spawn_inputbar:
		label.label_settings = LabelSettings.new()
		label.label_settings.font_size = default_font_size
	else:
		length_label.visible = false
	Singleton.btns.append(self)

func _on_waterfall_strums_toggled():
	var new_value = ConfigHandler.current_config.waterfall_strums
	visible = (true_index < 5 or (is_wide != ConfigHandler.current_config.waterfall_strums))
	spawn_inputbar = visible and not is_wide
	# no need to move waterfall strums or wide strums
	if true_index > 4:
		return
	# moving frets down if wide strums
	if new_value:
		position.y = 28
	else:
		position.y = 53

func colorize(new_color: Color):
	color = Color(new_color, center.color.a)
	center.color = color
	var border = $Border
	border.color = Color(color, border.color.a)
	self.set_meta("color", color)

func get_config_name(version):
	if version >= 2:
		return ConfigHandler.btn_config_names[index]
	else:
		return str(index)

func _mouse_enter():
	insideArea = true
	
func _mouse_exit():
	insideArea = false

func release(do_update_length: bool=false):
	pressed = false
	released.emit()
	if spawn_inputbar and do_update_length:
		update_length(Time.get_unix_time_from_system() - timestamp)

func update_length(new_length):
	length = new_length
	length_label.text = "%0.3f" % length

func _input(ev):

	if ev is InputEventJoypadMotion:
		var result = Singleton.process_axis_input(ev.device, ev.axis, ev.axis_value)
		if mapping:
			if not pressed and result["pressed"]:
				binding.set_binding_from_ev(ev)
				pressed = true
			elif pressed and not result["pressed"]:
				release()
				mapping = false
		elif ev.device == binding.gp_axis_device and ev.axis == binding.gp_axis:
			if not pressed and result["pressed"] and result["positive"] == binding.gp_axis_positive:
				update_input_counter()
			elif pressed and not result["pressed"]:
				release(true)
	if ev is InputEventJoypadButton:
		if mapping:
			if ev.pressed:
				binding.set_binding_from_ev(ev)
			else:
				mapping = false
		elif ev.button_index == binding.gp_btn:
				if ev.pressed:
					# Make sure the Input isnt a duplicate
					if Engine.get_process_frames() != gp_previous_framecount:
						gp_previous_framecount = Engine.get_process_frames()
						update_input_counter()
				else:
					release(true)
	if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT and insideArea:
		mapping = not mapping
	if ev is InputEventKey and not ev.echo:
		if mapping and ev.keycode not in banned_keycodes: # insert reserved keycodes here
			if ev.pressed:
				binding.set_binding_from_ev(ev)
			else:
				mapping = false
		else:
			if ev.keycode == KEY_BACKSPACE and ev.pressed: # backsp pressed; clear
				count = 0
				label.text = str(count)
				update_length(0)
			if ev.keycode == binding.kb_btn:
				if ev.pressed:
					update_input_counter()
				else:
					release(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressed and not mapping:
		if spawn_inputbar:
			length += delta
			length_label.text = "%0.3f" % length
	elif mapping:
		center.color.a = max_alpha
	else:
		if center.color.a > color.a:
			center.color.a -= fade_rate * delta
		else:
			center.color.a = color.a

func update_input_counter():
	pressed = true
	count += 1
	label.text = str(count)
	center.color.a = max_alpha
	timestamp = Time.get_unix_time_from_system()
	if spawn_inputbar:
		# resize text dynamically
		var font = label.get_theme_default_font()
		var width = font.get_string_size(label.text, label.horizontal_alignment, -1, default_font_size).x
		if (width > 46):
			var rate = 46 / width
			label.label_settings.font_size = default_font_size * rate
		#
		length = 0
		var new_inputbar = inputbar.instantiate()
		new_inputbar.set_caller(self)
		new_inputbar.color = color
		new_inputbar.timestamp = timestamp
		new_inputbar.x = self.position.x
		new_inputbar.y = self.position.y
		add_child(new_inputbar)
	# only append to inputs_gone if ips are visible
	# (inputs_gone is used for exclusively ips calculation)
	if ConfigHandler.current_config.show_ips and not is_wide:
		Singleton.inputs_gone.append(timestamp)

func as_waterfall():
	if is_wide:
		return Singleton.btns[index]
	return self
func get_binding():
	return as_waterfall().binding
func set_binding(new_binding: Binding):
	binding = new_binding
	if is_wide:
		as_waterfall().binding = new_binding