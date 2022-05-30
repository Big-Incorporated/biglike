extends Damageable

class_name Player

export var BaseSpeed: float
export var BaseDamage: int

var movementVector:Vector2;
var angle_to_mouse

var camera: Camera2D

onready var inventory: Array = [Pistol.new(),Shotgun.new()]
onready var invmodels: Array = []
var inventoryindex: int

onready var ModelBase = $Model/Viewport/model/base

func swap_weapon():
	var currentweaponmodel = $Model/Viewport/model/base/weapon
	ModelBase.remove_child(currentweaponmodel)
	ModelBase.add_child(invmodels[inventoryindex])
	inventory[inventoryindex].getAnim()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/GlobalPlayer").set_player(self)
	movementVector = Vector2(0,0)
	camera = $Camera2D
	inventoryindex = 0
	
	for n in range(0,inventory.size()):
		add_child(inventory[n])
		invmodels.append(inventory[n].ModelScene.instance())
		
	swap_weapon()

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_W and event.pressed:
			movementVector.y = -5
		elif event.scancode == KEY_S and event.pressed:
			movementVector.y = 5
		elif !Input.is_key_pressed(KEY_W) && !Input.is_key_pressed(KEY_S):
			movementVector.y = 0
		if event.scancode == KEY_A and event.pressed:
			movementVector.x = -5
		elif event.scancode == KEY_D and event.pressed:
			movementVector.x = 5
		elif !Input.is_key_pressed(KEY_A) && !Input.is_key_pressed(KEY_D):
			movementVector.x = 0
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			inventory[inventoryindex].shoot()
		elif event.button_index == BUTTON_WHEEL_UP  && event.pressed:
			if inventoryindex >0:
				inventoryindex-=1
			else:
				inventoryindex = inventory.size() -1
			swap_weapon()
		elif event.button_index == BUTTON_WHEEL_DOWN  && event.pressed:
			if inventoryindex < inventory.size()-1:
				inventoryindex += 1
			else:
				inventoryindex = 0
			swap_weapon()
func _process(_delta):
	ModelBase.rotation.y = -get_angle_to(get_global_mouse_position())
	

func _physics_process(delta):
	move_and_slide(movementVector*BaseSpeed)
