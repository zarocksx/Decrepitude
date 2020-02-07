extends Node

onready var level1 = preload("res://scene/rooms/level1.tscn");
onready var level2 = preload("res://scene/rooms/level2.tscn");
onready var level3 = preload("res://scene/rooms/level3.tscn");
onready var level4 = preload("res://scene/room/room.tscn");

onready var current_level = get_tree().get_root().get_node("Control/VideoPlayer");
onready var cam = get_tree().get_root().get_node("Control/Camera/camAnim");
onready var trans = get_tree().get_root().get_node("Control/transition");

var ARMOR_STR = ['1','0','0','0','1'];
var MOVE_STR = ['0','1','1','1','0'];
var GUN_STR = ['0','0','0','0','0'];
var KNIFE_STR = ['1','1','1','1','1'];

var mana = 0;
var life = 100;
var armor = 100;
var move = 100;
var gun = 100;
var knife = 100;
var level = 0;

var timer;
var combo = [];

func _ready():
	timer = Timer.new();
	timer.connect("timeout",self,"_on_timer_timeout");
	add_child(timer);
	pass;

func reset()-> void:
	mana = 0;
	life = 100;
	armor = 100;
	move = 100;
	gun = 100;
	knife = 100;
	pass;

func damage()-> void:
	var dmg = 100 / self.armor+1;

	if armor > 0:
		armor -= dmg;
	if move > 0:
		move -= dmg;
	if gun > 0:
		gun -= dmg;
	if knife > 0:
		knife -= dmg;

	if armor < 0:
		armor = 0;
	if move < 0:
		move = 0;
	if gun < 0:
		gun = 0;
	if knife < 0:
		knife = 0;
	
	if armor > 100:
		armor = 100;
	if move > 100:
		move = 100;
	if gun > 100:
		gun = 100;
	if knife > 100:
		knife = 100;

	update();
	pass;

func fillMana(amount = 10):
	mana += amount;
	pass;

func update()-> void:
	life = (armor + gun + knife + move) / 4;
	pass;

func _unhandled_input(event):
	timer.stop();
	timer.start(3);
	if event is InputEventKey:
		if event.pressed:
			var letter = OS.get_scancode_string(event.unicode);
			if letter != 'z' && letter != 'q' && letter != 's' && letter != 'd' && letter != '' :
				combo.push_back(letter);
				print(combo);
				check_combo();
	pass;

func _on_timer_timeout():
	combo.clear();
	pass;

func check_combo():
	if combo.size() == 5:
		match combo:
			ARMOR_STR:
				armor += mana
				mana = 0
			MOVE_STR:
				move += mana
				mana = 0
			GUN_STR:
				gun += mana
				mana = 0
			KNIFE_STR:
				knife += mana
				mana = 0
	if combo.size() > 4:
		combo.clear();
	pass;

func change_level():
	level += 1;
	trans.fade(true);
	yield(trans,"faded");
	get_tree().call_group("level","queue_free");
	match level:
		1:
			current_level = level1.instance();
			add_child(level1.instance());
		2:
			current_level = level2.instance();
			add_child(level2.instance());
		3:
			current_level = level4.instance();
			add_child(level4.instance());
	trans.raise();

func shake():
	cam.play("shake");
	pass;
