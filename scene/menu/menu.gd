extends Control

func _ready():
	pass;

func _on_play_pressed():
	game.change_level()
	pass;

func _on_VideoPlayer_tree_exiting():	
	pass;

func _on_quit_pressed():
	get_tree().quit();