extends TextureRect

func _ready():
	if not OS.has_feature("editor"):
		# The full preview circle is only for editing the layout in the editor,
		# So it is hidden if the program is not run through the editor.
		hide()
