extends Window

func _input(ev):
	if ev is InputEventKey:
		if not ev.echo and (ev.pressed and ev.keycode == KEY_ESCAPE):
			Singleton.update_spinboxes()
			hide()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		hide()
