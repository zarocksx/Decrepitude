extends KinematicBody2D

export(int) var posRange = 20;
onready var navMesh = get_node("..");
onready var ray = get_node("./RayCast2D");
onready var sprite = get_node("./Sprite");
onready var anim = get_node("AnimationPlayer");
var life = 3;
var hasTarget = false;
var player;
var path = [];
var randomZone = Vector2();

export(float) var CHARACTER_SPEED = 100.0;

func _process(delta):
	var walk_distance = CHARACTER_SPEED * delta;
	if life > 0:
		move_along_path(walk_distance);

func get_navigation_path(destination)->void:
    path = navMesh.get_simple_path( self.position, destination);
    navMesh.set_process(true);

func move_along_path(distance):
	var last_point = self.position;
	while self.path.size():
		var distance_between_points = last_point.distance_to(self.path[0]);

		if distance <= distance_between_points:
			if (self.position.x - last_point.linear_interpolate(self.path[0], distance / distance_between_points).x) > 0 :
				sprite.set_flip_h(true);
			else :
				sprite.set_flip_h(false);
			self.position = last_point.linear_interpolate(self.path[0], distance / distance_between_points);
			return;

		distance -= distance_between_points;
		last_point = self.path[0];
		self.path.remove(0);
	self.position = last_point;
	navMesh.set_process(false);

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

func _on_offset_timeout():
	randomize();
	randomZone= Vector2(rand_range( 0, posRange*2) - posRange, rand_range( 0, posRange*2) - posRange);
	if hasTarget :
		get_navigation_path(navMesh.get_closest_point(player.get_global_position()));
	else :
		get_navigation_path(navMesh.get_closest_point(self.get_global_position()+randomZone));

func damage():
	anim.play("damage");
	life -= 1;
	if life == 0:
		CHARACTER_SPEED = 0;
		game.mana += 10;
		sprite.set_animation("dead");

func _on_Sprite_animation_finished():
	if life < 1:
		anim.play("fade_out");

func faded():
	queue_free();
