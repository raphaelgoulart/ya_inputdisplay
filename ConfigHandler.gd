extends Node

# this script is used for all config file reading and writing

const Binding = preload ("res://Binding.gd")
const InputBtn = preload ("res://InputBtn.gd")
const Config = preload ("res://Config.gd")

const valid_config_versions = [1, 1.1, 2]

const legacy_color_section_keys = ["green", "red", "yellow", "blue", "orange", "up", "down"]
const btn_config_names = ["fret_0", "fret_1", "fret_2", "fret_3", "fret_4", "strum_up", "strum_down"]

var current_config: Config

func _ready():
	load_cfg()

var config_file: ConfigFile
func load_cfg():
	current_config = Config.new()
	config_file = ConfigFile.new()
	var err = config_file.load("user://yaid_settings.cfg")
	if err != OK:
		print("error reading settings file; using default values...")
		config_file = null
		return

	if config_file.has_section("Meta"):
		current_config.version = config_file.get_value("Meta", "config_version")
	else:
		current_config.version = 1
	
	current_config.scroll_rate = config_file.get_value("Settings", "scroll_rate", 400.0)
	if current_config.version < 2:
		current_config.input_bar_width = config_file.get_value("Settings", "width", 50)
	else:
		current_config.input_bar_width = config_file.get_value("Settings", "input_bar_width", 50)

	current_config.always_show_hamburger = config_file.get_value("Settings", "always_show_hamburger", true)
	# colors
	load_colors()

func load_colors():
	for i in 7:
		if config_file.has_section_key("Colors", color_index_to_config_key(i)):
			current_config.colors[i] = Color(config_file.get_value("Colors", color_index_to_config_key(i)), 1)

func load_binding(btn: InputBtn): # called by an inputbtn when it's _ready() function is called
	var section_name = btn.get_config_name(current_config.version)
	var result = Binding.new()
	if config_file == null:
		result.set_binding(InputSources.GP, btn.get_meta("gp_btn"))
		return result
	
	# default to v2 keys, if none are found, the default values will prevent any errors
	result.set_binding(
		config_file.get_value(section_name, "input_source", InputSources.GP),
		config_file.get_value(section_name, "binding", btn.get_meta("gp_btn")),
		config_file.get_value(section_name, "gp_axis_device", -2), # we can just attempt to supply the arguments for an axis binding
		config_file.get_value(section_name, "gp_axis_positive", true) # because they will be ignored anyways if current_input_source isn't GP_AXIS
	)

	if current_config.version < 2:
		var input_source: int = InputSources.NONE
		for i in 3: # iterates over all InputSources (except InputSources.NONE)
			if config_file.has_section_key(section_name, input_source_to_config_key(i)):
				input_source = i
				# dont break once a binding was found, so if multiple bindings exist in the config_file, the priority is gp_axis > gp_btn > kb_btn
		if input_source > InputSources.NONE: # legacy binding was found in the config_file, so use it
			result.set_binding(
				input_source,
				config_file.get_value(section_name, input_source_to_config_key(input_source)),
				config_file.get_value(section_name, "gp_axis_device", -2),
				config_file.get_value(section_name, "gp_axis_positive", true)
			)

	return result

var new_config_file # this are declared here so all config file saving methods can easily access it
var new_config_file_version
func save_config(version=2): # version should be either 1, 1.1 or 2

	new_config_file_version = version
	# Create new config_file file
	new_config_file = ConfigFile.new()

	# config_file version
	new_config_file.set_value("Meta", "config_version", new_config_file_version)
	
	# misc settings
	new_config_file.set_value("Settings", "scroll_rate", current_config.scroll_rate)

	if new_config_file_version < 2:
		new_config_file.set_value("Settings", "width", current_config.input_bar_width)
	else:
		new_config_file.set_value("Settings", "input_bar_width", current_config.input_bar_width)
	new_config_file.set_value("Settings", "always_show_hamburger", current_config.always_show_hamburger)
	# colors
	save_colors()

	# bindings
	save_bindings()

	# Save it to a file (overwrite if already exists).
	new_config_file.save("user://yaid_settings.cfg")
	
func save_colors():
	for i in 7:
		new_config_file.set_value("Colors", color_index_to_config_key(i, new_config_file_version), "#" + current_config.colors[i].to_html(false))

func save_bindings():
	for btn: InputBtn in Singleton.btns:
		var config_name = btn.get_config_name(new_config_file_version)
	
		var binding = btn.binding

		if new_config_file_version < 2:
			new_config_file.set_value(config_name, input_source_to_config_key(binding.current_input_source, new_config_file_version), binding.get_current_binding())
		else:
			new_config_file.set_value(config_name, "input_source", binding.current_input_source)
			new_config_file.set_value(config_name, "binding", binding.get_current_binding())
		if binding.current_input_source == InputSources.GP_AXIS:
			new_config_file.set_value(config_name, "gp_axis_device", binding.gp_axis_device)
			new_config_file.set_value(config_name, "gp_axis_positive", binding.gp_axis_positive)

func color_index_to_config_key(index: int, version: float=current_config.version):
	if version < 2:
		return legacy_color_section_keys[index]
	else:
		return btn_config_names[index]
	
func input_source_to_config_key(input_source: int, version: float=current_config.version):
	if input_source == InputSources.NONE:
		return "NONE"
	elif input_source == InputSources.KB:
		return "kb_btn" if version > 1 else "btn"
	elif input_source == InputSources.GP:
		return "gp_btn"
	elif input_source == InputSources.GP_AXIS:
		return "gp_axis"
