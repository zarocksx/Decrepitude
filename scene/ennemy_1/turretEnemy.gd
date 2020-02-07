extends KinematicBody2D

onready var bullet = preload("res://scene/bullet/badBullet.tscn");
onready var anim = get_node("AnimationPlayer");
onready var sprite = get_node("./Sprite");
onready var ray = get_node("./RayCast2D");

var hasTarget = false
var life = 2 ;
var player;

func _on_detectPlayer_body_entered(target):
	ray.set_enabled(true);
	ray.set_cast_to((target.get_global_position() - self.get_global_position()));
	if target.is_in_group("player"):
		hasTarget = true;
		player = target;
	else:
		ray.set_enabled(false);

func _on_detectPlayer_body_exited(target):
	if target.is_in_group("player"):
		ray.set_enabled(false);
		hasTarget = false;

func _process(delta):
	if hasTarget && ray.is_enabled():
		ray.set_cast_to((player.get_global_position() - self.get_global_position())*4.5);

func _on_Timer_timeout():
	if hasTarget && ray.is_enabled() :
			var currentBullet = bullet.instance();
			get_tree().get_root().add_child(currentBullet);
			currentBullet.shoot(player.get_global_position(), global_position);

func damage():
	anim.play("damage");
	life -= 1;
	if life == 0:
		game.mana += 10;
		sprite.set_animation("dead");

func _on_Sprite_animation_finished():
	if life < 1:
		anim.play("fade_out");

func faded():
	queue_free();