extends ColorRect

signal faded;
onready var anim = get_node("AnimationPlayer");

func fade(revert=false):
	if revert:
		anim.play("fade_out");
	else:
		anim.play("fade_in");
	pass;

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("faded");
	if anim_name == "fade_out" :
		fade();
	pass 
