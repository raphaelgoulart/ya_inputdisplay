extends Node2D

func _ready():
	Singleton.post_init()
	ConfigHandler.post_init()