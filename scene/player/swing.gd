extends Node2D

onready var sprite = get_node("./AnimatedSprite");
onready var area = get_node("./AnimatedSprite/Area2D");
var isAtacking = false;

func swing():
	sprite.play("swing");
	isAtacking = true;
	attack();

func turn(toLeft):
	scale.x = 1;
	if toLeft:
		scale.x = -1;
	pass;


func _on_AnimatedSprite_animation_finished():
	sprite.stop();
	isAtacking = false;
	pass;

func _on_physics_process():
	if isAtacking :
		attack();

func attack():
	if area.get_overlapping_bodies().size() > 0:
		for body in area.get_overlapping_bodies():
			if body.is_in_group("enemy"):
				body.queue_free();
				if get_tree().get_nodes_in_group("enemy").size() < 2 :
					game.change_level();
	pass;