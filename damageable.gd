extends KinematicBody2D

class_name Damageable

export var MaxHealth : int

onready var Parent = get_parent()

var CurrentHealth: int
var alive: bool

signal damaged
signal healed
signal died

func die():
	queue_free()

func _exit_tree():
	die()

func damage(var amount:int):
	CurrentHealth -= amount
	emit_signal("damaged")
	if CurrentHealth <= 0:
		CurrentHealth = 0
		alive = false
		emit_signal("died")
		get_parent().remove_child(self)

func heal(var amount:int):
	CurrentHealth += amount

func _ready():
	CurrentHealth = MaxHealth
	alive = true
