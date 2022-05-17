extends Sprite


var Body:KinematicBody2D

func _ready():
	Body = get_node("/root/Node2D/Navigation2D/YSort/PlayerBody")


func _process(delta):
	global_position = Body.global_position
	global_position.y -= 25.6
