extends Weapon

class_name Sword

var damage = 20

var shooting = false

var HitList = []

var HitBox : Area2D
var HitShape : CollisionShape2D

var parent

func _ready():
	ModelScene = preload("res://models/weapons/sword/sword.tscn")
	
	parent = get_parent()
	
	HitShape = CollisionShape2D.new()
	HitShape.shape = RectangleShape2D.new()
	HitShape.shape.extents = Vector2(50,25)
	HitBox = Area2D.new()
	add_child(HitBox)
	HitBox.add_child(HitShape)
	HitBox.translate(Vector2(0,HitShape.shape.extents.y))

func shoot():
	if Anim.is_playing():
		return
	else:
		Anim.play("jordan swing",-1,1.8)
	
	global_rotation = parent.get_angle_to(get_global_mouse_position()) - deg2rad(90)
	yield(get_tree().create_timer(0.15),"timeout")
	shooting = true
	yield(get_tree().create_timer(0.15),"timeout")
	shooting = false

func shootstate():
	var FrameHit = HitBox.get_overlapping_bodies()
	for n in FrameHit:
		if !(n in HitList) && n is Damageable && n != globalplayer:
			HitList.append(n)
			n.damage(damage)
	
func _process(delta):
	if shooting:
		shootstate()
