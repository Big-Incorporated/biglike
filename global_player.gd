extends Node
var player setget set_player, get_player


func set_player(p):
	player = p

func get_player():
	return player

onready var tileset = preload("res://tiles/tileset.tres")
