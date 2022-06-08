extends Weapon

class_name Pistol

var damage:int = 3

func _ready():
	AmmoType = "bullets"
	set_weapon_info(damage,60,7)
	ModelScene = preload("res://models/weapons/pistol/hand_cannon.tscn")
	parent = get_parent()

func _fire():
	if Anim.current_animation == "reload":
		return
	Anim.stop()
	Anim.play("shoot",-1,3.0)
	shootbullet(damage,global_position,get_angle_to(get_global_mouse_position()))
	._fire()

func _reload():
	Anim.play("reload")
	._reload()
