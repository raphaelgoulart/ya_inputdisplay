extends Label

func _process(_delta):
	set_text("FPS: " + str(Engine.get_frames_per_second()))
