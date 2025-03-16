extends Node

# mostly a convenience class

var current_input_source: int = InputSources.NONE
var kb_btn: int = -1
var gp_btn: int = -1
var gp_axis: int = -1
var gp_axis_device: int = -2 # cant use -1 because it is a constant for emulated mouse inputs for InputEvent.device
var gp_axis_positive: bool = true

# device and axis_positive are only needed if an axis binding is being set
func set_binding(input_source: int, binding: int, device: int=- 2, axis_positive: bool=true):
	clear_bindings()

	if input_source == InputSources.GP_AXIS:
		gp_axis = binding
		gp_axis_device = device
		gp_axis_positive = axis_positive

	elif input_source == InputSources.GP:
		gp_btn = binding

	elif input_source == InputSources.KB:
		kb_btn = binding

	else:
		print_debug("invalid input source was supplied at BindingSet.set_binding:")
		print("set_binding(" + str(input_source) + ", " + str(binding) + ", " + str(device) + ", " + str(axis_positive) + ")")

	current_input_source = input_source

func set_binding_from_ev(ev: InputEvent):
	if ev is InputEventJoypadMotion:
		set_binding(InputSources.GP_AXIS, ev.axis, ev.device, ev.axis_value > 0)
	elif ev is InputEventJoypadButton:
		set_binding(InputSources.GP, ev.button_index)
	elif ev is InputEventKey:
		set_binding(InputSources.KB, ev.keycode)

func clear_bindings():
	current_input_source = InputSources.NONE
	kb_btn = -1
	gp_btn = -1
	gp_axis = -1
	gp_axis_device = -2
	gp_axis_positive = true

func get_current_binding():
	if current_input_source == InputSources.KB:
		return kb_btn
	elif current_input_source == InputSources.GP:
		return gp_btn
	elif current_input_source == InputSources.GP_AXIS:
		return gp_axis
	else:
		return InputSources.NONE
