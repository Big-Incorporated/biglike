extends Weapon

class_name Shotgun

export var numpellets:int = 10
export var pelletdamage:int = 2



onready var projectilescene = preload("res://weapons/projectiles/shotgunpellet.tscn")

func _ready():
	AmmoType = "shells"
	set_weapon_info(13,50,1)
	ModelScene = preload("res://models/weapons/dbshotgun/dbshotgun.tscn")

func _fire():
	if Anim.is_playing():
		return
	Anim.play("animationshotgunshoot")
	
	if parent == globalplayer:
		for n in numpellets:
			shootbullet(pelletdamage,global_position,get_angle_to(get_global_mouse_position()))
	else:
		for n in numpellets:
			shootprojectile(projectilescene.instance(),global_position,get_angle_to(parent.Target.global_position))
	._fire()

func _reload():
	yield( Anim, "animation_finished" )
	Anim.play("animationshotgunreload")
	._reload()
