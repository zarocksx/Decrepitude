extends KinematicBody2D

export (float) var rotSpeed = 0;
export (float) var speed = 0;
export (float) var shootSpeed = 0;

onready var bullet = preload("res://scene/bullet/Bullet.tscn");
onready var shader = preload("res://hologram_shader.tres");
onready var invi_sprite = preload("res://assets/player/Idle/Idle_Aim__000.png");
onready var audio = preload("res://scene/audio/lazer.tscn");
onready var reload = get_node("reload");
onready var invi = get_node("invi");
onready var sprite = get_node("Sprite");
onready var swing = get_node("swing");


var isReloading = false;
var isSwinging = false;
var isInvi = false;
var velocity = Vector2();
var speedCoef;
var shootCoef;

func _ready():
    speed = speed / 100;
    speedCoef = game.move;
    shootCoef = game.gun;
    sprite.set_use_parent_material(true);
    pass;

func _process(delta):
    if game.life > 0 && game.level > 0:
        self.get_input();
        self.velocity = move_and_slide(velocity);
        
    if Input.is_action_pressed("key_exit"):
            get_tree().quit()
    
    pass;

func rotate_to_mouse()-> void:
    if (get_global_mouse_position().x - global_position.x) > 0:
        turn(true);
    pass;

func get_input()-> void:
    if Input.is_action_pressed("click"):
        shoot();
    if Input.is_action_pressed("cac") && !isSwinging:
        swing.swing();
    velocity = Vector2();
    if Input.is_action_pressed('right'):
        sprite.play("run_shoot");
        turn(false);
        velocity.x += 1;
    if Input.is_action_pressed('left'):
        sprite.play("run_shoot");
        turn(true)
        velocity.x -= 1;
    if Input.is_action_pressed('down'):
        sprite.play("run_shoot");
        velocity.y += 1;
    if Input.is_action_pressed('up'):
        sprite.play("run_shoot");
        velocity.y -= 1;
    velocity = velocity.normalized() * speed * speedCoef;
    pass;

func shoot():
    if !isReloading:
        
        var currentBullet = bullet.instance();
        get_tree().get_root().add_child(currentBullet);
        currentBullet.shoot(get_global_mouse_position(), global_position);

        var audioBullet = audio.instance();
        get_tree().get_root().add_child(audioBullet);
        isReloading = true;

        reload.start(shootSpeed / (shootCoef+0.1) * 2);

func _unhandled_input(event):
    if event is InputEventKey:
        if !event.pressed:
            sprite.play("idle");
 

func  _on_reload_timeout():
    reload.stop();
    isReloading = false;

func damage():
    if !isInvi :
        game.damage();
        speedCoef = game.move;
        shootCoef = game.gun;
        sprite.set_use_parent_material(false);
        isInvi = true;
        invi.start();
    pass;

func turn(toLeft):
    sprite.set_flip_h(toLeft);
    swing.turn(toLeft);
    pass;

func _on_invi_timeout():
    sprite.set_use_parent_material(true);
    isInvi = false;

func _on_enmiCol_body_entered(body):
    if body.is_in_group("enemy"):
        damage();