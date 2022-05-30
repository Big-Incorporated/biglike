extends Weapon

class_name Pistol

var damage:int = 3

var parent: Node2D

var ModelScene


func _ready():
	set_weapon_info(3,60,10)
	ModelScene = preload("res://models/weapons/pistol/pistol.tscn")
	parent = get_parent()

func shoot():
	if Anim.is_playing():
		return
	else:
		Anim.play("animationpistolshoot")
	
	if parent == globalplayer:
		shootbullet(damage,global_position,parent.camera.get_camera_screen_center(),get_angle_to(get_global_mouse_position()))
	else:
		shootbullet(damage,global_position,parent.global_position,get_angle_to(parent.Target.global_position))
	.shoot()
