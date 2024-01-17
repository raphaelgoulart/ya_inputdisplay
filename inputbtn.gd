extends Area2D

const inputbar = preload("res://input_bar.tscn")
var btn
var gp_btn
var label
var center
var color
var count = 0
var max_a = 0.5
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

# Called when the node enters the scene tree for the first time.
func _ready():
	btn = get_meta("btn")
	gp_btn = get_meta("gp_btn")
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
	index = get_meta("index")
	#
	if (spawn_inputbar):
		label.label_settings = LabelSettings.new()
		label.label_settings.font_size = default_font_size
	
func _mouse_enter():
	insideArea = true
	
func _mouse_exit():
	insideArea = false
	
func _input(ev):
	if ev is InputEventJoypadButton:
		if mapping:
			if ev.pressed:
				gp_btn = ev.button_index
			else:
				mapping = false
		elif ev.button_index == gp_btn:
				if ev.pressed:
					update_input_counter(false)
				else:
					pressed = false
					if spawn_inputbar:
						length = Time.get_unix_time_from_system() - timestamp
						length_label.text = "%0.3f" % length
	if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT and insideArea:
		mapping = not mapping
	if ev is InputEventKey and not ev.echo:
		if mapping and ev.keycode not in [45, 4194308]: # [-,backsp]; insert other reserved keycodes here
			if ev.pressed:
				btn = ev.keycode
			else:
				mapping = false
		else:
			if ev.keycode == 45 and ev.pressed: # - pressed; clear
				count = 0
				label.text = str(count)
				length = 0
				length_label.text = "%0.3f" % length
			if ev.keycode == btn:
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
		center.color.a = max_a
	else:
		if center.color.a > color.a:
			center.color.a -= fade_rate * delta
		else:
			center.color.a = color.a
	

func update_input_counter(kb = true):
	pressed = true
	count = count + 1
	label.text = str(count)
	center.color.a = max_a
	timestamp = Time.get_unix_time_from_system()
	if spawn_inputbar:
		# resize text dynamically # TODO: (test more, up to the thousands)
		var font = label.get_theme_default_font()
		var w = font.get_string_size(label.text, label.horizontal_alignment, -1, default_font_size).x
		if (w > 46):
			var rate = w/46
			label.label_settings.font_size = default_font_size/rate
		#
		length = 0
		var new_inputbar = inputbar.instantiate()
		new_inputbar.kb = kb
		new_inputbar.btn = btn
		new_inputbar.gp_btn = gp_btn
		new_inputbar.color = color
		new_inputbar.timestamp = timestamp
		new_inputbar.x = self.position.x
		new_inputbar.y = self.position.y
		add_child(new_inputbar)
	Singleton.inputs_gone.append(timestamp)
