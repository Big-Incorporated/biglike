extends Node2D

class_name Weapon

var Spread: float# Spread in degrees, does nothing for melee weapons
var AttackRange: float # in whatever stupid units godot uses /10
var ClipSize: int

onready var globalplayer = get_node("/root/GlobalPlayer").get_player()
var Anim:AnimationPlayer 

var InClip: int

func getAnim():
	Anim = get_parent().get_node("Model/Viewport/model/base/weapon/AnimationPlayer")

func set_weapon_info(spread,attackrange,clipsize):
	Spread = spread
	AttackRange = attackrange*10
	ClipSize = clipsize
	InClip = ClipSize
	

func shoot():
	InClip -= 1
	if InClip <= 0:
		reload()

func reload():
	InClip = ClipSize

func tracer(startpos:Vector2,endpos:Vector2):
	var tracerline = TracerLine.new()
	tracerline.width = 2
	get_tree().root.add_child(tracerline)
	tracerline.trace(startpos, endpos)

func shootbullet(damage: int, position: Vector2,screenpos:Vector2,direction: float):
	var space_state = get_world_2d().direct_space_state
	var Spreadradians = rand_range(-deg2rad(Spread), deg2rad(Spread))
	var endposition = position + Vector2(cos(direction+Spreadradians), sin(direction+Spreadradians)) * AttackRange
	var result = space_state.intersect_ray(position, endposition,[self,get_parent()])
	if result:
		if result.collider is Damageable:
			result.collider.damage(damage)
			if result.collider is Enemy:
				result.collider.set_target(get_parent())
		tracer(screenpos,result.position)

func shootprojectile(projectilescene: Resource, position: Vector2,direction: float):
	var projectile = projectilescene.instance()
	add_child(projectile)
	projectile.transform = transform
