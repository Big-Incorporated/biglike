extends Node2D

export var PathToBody:NodePath
export var Offset:Vector2

var Body: KinematicBody2D

func _ready():
	Body = get_node(str(PathToBody))

func _process(delta):
	global_position = Body.global_position + Offset
