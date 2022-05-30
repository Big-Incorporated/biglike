extends Weapon

class_name Shotgun

export var numpellets:int = 10
export var pelletdamage:int = 2


var parent: Node2D
var ModelScene

func _ready():
	set_weapon_info(13,50,1)
	ModelScene = preload("res://models/weapons/dbshotgun/dbshotgun.tscn")
	parent = get_parent()

func shoot():
	if Anim.is_playing():
		return
	else:
		Anim.play("animationshotgunshoot")
	
	if parent == globalplayer:
		for n in numpellets:
			shootbullet(pelletdamage,global_position,parent.camera.get_camera_screen_center(),get_angle_to(get_global_mouse_position()))
	else:
		for n in numpellets:
			shootbullet(pelletdamage,global_position,parent.global_position,get_angle_to(parent.Target.global_position))
	.shoot()

func reload():
	yield( Anim, "animation_finished" )
	Anim.play("animationshotgunreload")
	.reload()
