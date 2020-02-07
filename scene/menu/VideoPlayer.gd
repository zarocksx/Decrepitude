extends VideoPlayer

func _ready():
	pass;

func _on_VideoPlayer_finished():
	self.play();
	pass;