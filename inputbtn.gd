extends Area2D

const inputbar = preload("res://input_bar.tscn")
var kb_btn
var gp_btn
var gp_axis
var gp_axis_device
var gp_axis_positive = true
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

# This is kept track of to detect duplicate inputs.
var gp_previous_framecount = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	index = get_meta("index")
	# bindings
	if Singleton.config_version == 1.1: # this has to be checked incase a config with an older version is read
		kb_btn = Singleton.config.get_value(str(index), "kb_btn", get_meta("kb_btn"))
	else:
		kb_btn = Singleton.config.get_value(str(index), "btn", get_meta("kb_btn"))
	gp_btn = Singleton.config.get_value(str(index), "gp_btn", get_meta("gp_btn"))
	gp_axis = Singleton.config.get_value(str(index), "gp_axis", null)
	gp_axis_device = Singleton.config.get_value(str(index), "gp_axis_device", null)
	gp_axis_positive = Singleton.config.get_value(str(index), "gp_axis_positive", true)
	# colors and visual stuff
	self.set_meta("color",Color(Singleton.colors[index]))
	label = $VBoxContainer/Label
	center = $Center
	var old_a = center.color.a
	center.color = get_meta("color")
	center.color.a = old_a
	var border = $Border
	old_a = border.color.a
	border.color = get_meta("color")
	border.color.a = old_a
	color = center.color
	spawn_inputbar = get_meta("inputbar")
	length_label = $Length
	if not spawn_inputbar: length_label.visible = false
	#
	if (spawn_inputbar):
		label.label_settings = LabelSettings.new()
		label.label_settings.font_size = default_font_size
	
func _mouse_enter():
	insideArea = true
	
func _mouse_exit():
	insideArea = false
	
func _input(ev):
	if ev is InputEventJoypadMotion:
		if mapping:
			var result = Singleton.process_axis_input(ev.device,ev.axis,ev.axis_value)
			if not pressed and result["pressed"]:
				kb_btn = null
				gp_btn = null
				gp_axis = ev.axis
				gp_axis_device = ev.device
				gp_axis_positive = result["positive"]
				pressed = true
			elif pressed and not result["pressed"]:
				pressed = false
				mapping = false
		elif ev.device == gp_axis_device and ev.axis == gp_axis:
			var result = Singleton.process_axis_input(ev.device,ev.axis,ev.axis_value)
			if not pressed and result["pressed"] and result["positive"] == gp_axis_positive:
				update_input_counter(false)
			elif pressed and not result["pressed"]:
				pressed = false
				if spawn_inputbar:
					length = Time.get_unix_time_from_system() - timestamp
					length_label.text = "%0.3f" % length
			
	if ev is InputEventJoypadButton:
		if mapping:
			if ev.pressed:
				gp_axis = null
				kb_btn = null
				gp_btn = ev.button_index
			else:
				mapping = false
		elif ev.button_index == gp_btn:
				if ev.pressed:
					# Make sure the Input isnt a duplicate
					if Engine.get_process_frames() != gp_previous_framecount:
						gp_previous_framecount = Engine.get_process_frames()
						update_input_counter(false)
				else:
					pressed = false
					if spawn_inputbar:
						length = Time.get_unix_time_from_system() - timestamp
						length_label.text = "%0.3f" % length
	if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT and insideArea:
		mapping = not mapping
	if ev is InputEventKey and not ev.echo:
		if mapping and ev.keycode not in [4194308, 45, 61, 91, 93, 96]: # insert reserved keycodes here
			if ev.pressed:
				gp_axis = null
				gp_btn = null
				kb_btn = ev.keycode
			else:
				mapping = false
		else:
			if ev.keycode == 4194308 and ev.pressed: # backsp pressed; clear
				count = 0
				label.text = str(count)
				length = 0
				length_label.text = "%0.3f" % length
			if ev.keycode == kb_btn:
				if ev.pressed:
					update_input_counter(true)
				else:
					pressed = false
					if spawn_inputbar:
							length = Time.get_unix_time_from_system() - timestamp
							length_label.text = "%0.3f" % length

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
	

func update_input_counter(kb = true):
	pressed = true
	count = count + 1
	label.text = str(count)
	center.color.a = max_alpha
	timestamp = Time.get_unix_time_from_system()
	if spawn_inputbar:
		# resize text dynamically
		var font = label.get_theme_default_font()
		var w = font.get_string_size(label.text, label.horizontal_alignment, -1, default_font_size).x
		if (w > 46):
			var rate = 46/w
			label.label_settings.font_size = default_font_size*rate
		#
		length = 0
		var new_inputbar = inputbar.instantiate()
		new_inputbar.kb = kb
		new_inputbar.kb_btn = kb_btn
		new_inputbar.gp_btn = gp_btn
		new_inputbar.gp_axis = gp_axis
		new_inputbar.gp_axis_device = gp_axis_device
		new_inputbar.gp_axis_positive = gp_axis_positive
		new_inputbar.color = color
		new_inputbar.timestamp = timestamp
		new_inputbar.x = self.position.x
		new_inputbar.y = self.position.y
		add_child(new_inputbar)
	Singleton.inputs_gone.append(timestamp)
