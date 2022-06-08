extends Item

class_name ShotgunPickup

onready var ShotgunNode = get_node("Viewport/Camera2/weapon")

func _ready():
	ModelScene = preload("res://models/weapons/dbshotgun/dbshotgun.tscn")

func _process(delta):
	ShotgunNode.rotate_object_local(Vector3(0,1,0),delta*4)

func _pickup(body):
	if body.Ammo.has("shells"):
		body.Ammo["shells"] += 4
	else:
		var shotgun = Shotgun.new()
		body.add_child(shotgun)
		body.inventory.append(shotgun)
		body.invmodels.append(shotgun.ModelScene.instance())
		body.inventoryindex = body.inventory.size() -1
		body.swap_weapon()
		body.Ammo["shells"] = 4
	._pickup(body)
