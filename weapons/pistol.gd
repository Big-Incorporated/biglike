extends Weapon

class_name Pistol

var damage:int = 3

var parent: Node2D

func _ready():
	set_weapon_info(damage,60,7)
	ModelScene = preload("res://models/weapons/pistol/hand_cannon.tscn")
	parent = get_parent()

func shoot():
	if Anim.current_animation == "reload":
		return
	Anim.stop()
	Anim.play("shoot",-1,3.0)
	
	if parent == globalplayer:
		shootbullet(damage,global_position,get_angle_to(get_global_mouse_position()))
	else:
		shootbullet(damage,global_position,get_angle_to(parent.Target.global_position))
	.shoot()

func reload():
	Anim.play("reload")
	.reload()
