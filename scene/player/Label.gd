extends Label

func _ready():
	text = '';
	pass # Replace with function body.

func _process(delta):
	text = setText();
	pass

func setText():
	var combo = "";
	for code in game.combo:
		combo += code;
	return combo;