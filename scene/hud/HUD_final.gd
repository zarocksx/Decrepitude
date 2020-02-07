extends TextureRect

onready var mana = get_node("mana");
onready var life = get_node("life");
onready var armor = get_node("armor");
onready var move = get_node("move");
onready var gun = get_node("gun");
onready var knife = get_node("knife");

func _ready():
	mana.value = game.mana;
	life.value = game.life;
	armor.value = game.armor;
	move.value = game.move;
	gun.value = game.gun;
	knife.value = game.knife;
	pass # Replace with function body.


func _process(delta):
	mana.value = game.mana;
	life.value = game.life;
	armor.value = game.armor;
	move.value = game.move;
	gun.value = game.gun;
	knife.value = game.knife;
	pass


func _on_Timer_timeout():
	game.armor -= 0.1;
	game.move -= 0.1;
	game.gun -= 0.1;
	game.knife -= 0.1;
	game.update();
	pass # Replace with function body.
