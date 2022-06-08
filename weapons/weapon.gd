extends Node2D

class_name Weapon

var Spread: float# Spread in degrees, does nothing for melee weapons
var AttackRange: float # in whatever stupid units godot uses /10
var ClipSize: int
var AltClipSize: int

onready var globalplayer = get_node("/root/GlobalPlayer").get_player()
var Anim:AnimationPlayer 
var ModelScene
var InClip: int
var InAltClip: int

var parent: Node2D

var AmmoType: String
var AltAmmoType: String

func _ready():
	parent = get_parent()

func getAnim():
	Anim = get_parent().get_node("Model/Viewport/model/base/weapon/AnimationPlayer")

func set_weapon_info(spread,attackrange,clipsize):
	Spread = spread
	AttackRange = attackrange*10
	ClipSize = clipsize
	InClip = ClipSize
	

func _fire():
	InClip -= 1
	if InClip <= 0:
		_reload()
		
func _alt_fire():
	InAltClip -= 1
	if InClip <= 0:
		_alt_reload()

func _reload():
	if parent == globalplayer:
		if parent.Ammo.has(AmmoType):
			if parent.Ammo[AmmoType] >= ClipSize:
				parent.Ammo[AmmoType] -= ClipSize
	InClip = ClipSize

func _alt_reload():
	if parent == globalplayer:
		if parent.Ammo.has(AltAmmoType):
			if parent.Ammo[AltAmmoType] >= AltClipSize:
				parent.Ammo[AltAmmoType] -= AltClipSize
	InAltClip = AltClipSize

func tracer(startpos:Vector2,endpos:Vector2):
	var tracerline = TracerLine.new()
	tracerline.width = 2
	get_tree().root.add_child(tracerline)
	tracerline.trace(startpos, endpos)

func shootbullet(damage: int, position: Vector2,direction: float):
	var space_state = get_world_2d().direct_space_state
	var Spreadradians = rand_range(-deg2rad(Spread), deg2rad(Spread))
	var endposition = position + Vector2(cos(direction+Spreadradians), sin(direction+Spreadradians)) * AttackRange
	var result = space_state.intersect_ray(position, endposition,[self,get_parent()])
	if result:
		if result.collider is Damageable:
			result.collider.damage(damage)
			if result.collider is Enemy:
				result.collider.set_target(get_parent())
		tracer(position,result.position)

func shootprojectile(projectile: Projectile, position: Vector2,direction: float):
	projectile.Parent = get_parent()
	projectile.add_to_group("projectiles")
	get_tree().root.add_child(projectile)
	projectile.global_position = position
	var Spreadradians = rand_range(-deg2rad(Spread), deg2rad(Spread))
	projectile.global_rotation = direction + Spreadradians
