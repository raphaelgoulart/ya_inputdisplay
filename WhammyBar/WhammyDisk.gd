extends Control

var center_pos: Vector2

const start_angle: int = 90
const max_relative_angle: int = 180
const arc_radius = 50
const direction = COUNTERCLOCKWISE
var current_angle: float = start_angle
var input_range = {"min": (-1), "max": 1}
var previous_points_arc
var background: Polygon2D
var collision: CollisionPolygon2D

func _ready():
	get_node("Area2D").mouse_entered.connect(_on_mouse_enter)
	get_node("Area2D").mouse_exited.connect(_on_mouse_exit)
	setup_draw_stuff()

func setup_draw_stuff():
	collision = get_node("Area2D/Collision")
	background = get_node("Area2D/Background")

	center_pos = Vector2(arc_radius, arc_radius)
	var points_arc = make_circle_arg_poly_points(center_pos, arc_radius, start_angle, start_angle - max_relative_angle)

	collision.set_polygon(points_arc)
	background.set_polygon(points_arc)

const regular_alpha = 0.6
const regular_background_alpha = 0.8
func _draw():
	var new_alpha = regular_alpha
	var new_bg_alpha = regular_alpha
	if mapping:
		new_alpha = 0.8
		new_bg_alpha = 1
	draw_circle_arc_poly(center_pos, arc_radius, start_angle, current_angle, Color(1, 0, 1, new_alpha))
	background.color.a = new_bg_alpha
var axis_binding = -1
var device_binding = -2

# yes, some of this is copied from inputbtn
var insideArea = false
var mapping = false
var pressed = false
func _on_mouse_enter():
	insideArea = true
	#print("enter")
	
func _on_mouse_exit():
	insideArea = false
	#print("exit")

func set_mapping(value: bool):
	mapping = value
	queue_redraw()

func _input(ev):
	if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT and insideArea:
		set_mapping(not mapping)
	if ev is InputEventJoypadMotion:
		var result = Singleton.process_axis_input(ev.device, ev.axis, ev.axis_value)
		if axis_binding == (-1) and device_binding == (-2):
			if result["pressed"]:
				axis_binding = ev.axis
				device_binding = ev.device
				print("using device " + str(device_binding) + " axis " + str(axis_binding))
		
		if mapping:
			if not pressed and result["pressed"]:
				device_binding = ev.device
				axis_binding = ev.axis
				pressed = true
			elif pressed and not result["pressed"]:
				pressed = false
				set_mapping(false)
		
		elif ev.axis == axis_binding and ev.device == device_binding:
			var input_range_size = input_range["max"] - input_range["min"]
			var axis_value_from_zero = ev.axis_value - input_range["min"]
			var fraction: float = axis_value_from_zero / input_range_size
			current_angle = start_angle - fraction * max_relative_angle
			queue_redraw()

# base for this is from https://docs.godotengine.org/en/4.0/tutorials/2d/custom_drawing_in_2d.html#arc-polygon-function
# i have little idea of why these work mathmatically
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var points_arc = make_circle_arg_poly_points(center, radius, angle_from, angle_to)
	previous_points_arc = points_arc
	var colors = PackedColorArray([color])
	draw_polygon(points_arc, colors)

func make_circle_arg_poly_points(center, radius, angle_from, angle_to):
	var nb_points = 64
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	return points_arc
