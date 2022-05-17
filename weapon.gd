extends Node

class_name Weapon

var damage:int
var spread:float# spread in degrees, does nothing for melee weapons
var attackrange:float #used only for melee weapons on the player

enum type{WEAPON_MELEE,WEAPON_HITSCAN,WEAPON_PROJECTILE}


func _ready():
	pass
