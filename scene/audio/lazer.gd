extends AudioStreamPlayer2D

func _ready():
	play();
	pass #

func _on_AudioStreamPlayer2D_finished():
	stop();
	queue_free();