extends Area2D

class_name Item

var ModelScene

var PickupText: String

var global_player

func _ready():
	global_player = get_node("/root/GlobalPlayer").player
	connect("body_entered",self,"_check_pickup")

func _check_pickup(body):
	if body == global_player:
		_pickup(body)

func _pickup(body):
	queue_free()
