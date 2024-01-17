extends Node

var released = false
var kb
var btn
var gp_btn
var color
var size_rate = 400
var rect
var timestamp
var x
var y

# Called when the node enters the scene tree for the first time.
func _ready():
	rect = $ColorRect
	rect.color = color
	rect.color.a = 1
	rect.position.x = x
	rect.position.y += y
	
func _input(ev):
	if not released:
		if kb and ev is InputEventKey and ev.keycode == btn and not ev.pressed:
			bar_release()
		if not kb and ev is InputEventJoypadButton and ev.button_index == gp_btn and not ev.pressed:
			bar_release()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rect.position.y > get_viewport().get_visible_rect().size.y:
		call_deferred("free")
	if released:
		rect.position.y += size_rate * delta
	else:
		rect.scale.y += size_rate * delta

func bar_release():
	released = true
	rect.scale.y = (Time.get_unix_time_from_system() - timestamp) * size_rate
	if (rect.scale.y < 1): rect.scale.y = 1
