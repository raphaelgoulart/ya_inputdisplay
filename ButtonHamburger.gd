extends TextureButton

const config_interface_scene = preload ("res://ConfigInterface/ConfigInterface.tscn")

var current_alpha: float
var target_alpha: float = 1
const anim_speed: float = 3 # higher value = faster fade in/out

func _ready():
	pressed.connect(Singleton.show_config_window)

	if not ConfigHandler.current_config.always_show_hamburger:
		target_alpha = 0
	current_alpha = target_alpha
	modulate.a = target_alpha

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta):
	anim_step(delta)

func anim_step(delta):
	# there is no need for checking if current_alpha is equal to target_alpha,
	# because if they are, (target_alpha - current_alpha) * delta = 0 * delta = 0
	# It is done anyways for clarity :3
	if current_alpha != target_alpha:
		current_alpha += (target_alpha - current_alpha) * delta * anim_speed
		current_alpha = clampf(current_alpha, 0, 1) # could be combined into the previous line but it's more readable like this

		# 2.2 is ease in, 0.2 is ease out.
		# Using ease in if target alpha is 1 or vice versa feels very slow.
		modulate.a = ease(current_alpha, 2.2 - target_alpha * 2)

func change_to_alpha(new_alpha: float):
	target_alpha = new_alpha

func _on_mouse_entered():
	change_to_alpha(1)
func _on_mouse_exited():
	if not ConfigHandler.current_config.always_show_hamburger:
		change_to_alpha(0)
