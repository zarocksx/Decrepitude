extends Area2D

var direction = Vector2();
export var speed = 1;

func shoot(aim_position, gun_position):
    global_position = gun_position;
    direction = (aim_position - gun_position).normalized();
    rotation = direction.angle();

func _process(delta):
    position += direction * speed * delta;

func _on_Bullet_body_entered(body):
    if body.is_in_group("enemy"):
        body.damage();
        game.shake();
        if get_tree().get_nodes_in_group("enemy").size() < 2:
            game.change_level();
    if !body.is_in_group("player"):
        self.queue_free();
        pass;
