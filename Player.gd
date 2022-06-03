extends Damageable

class_name Player

export var BaseSpeed: float
export var BaseDamage: int

var movementVector:Vector2;
var angle_to_mouse

var camera: Camera2D

onready var inventory: Array = [Pistol.new(),Shotgun.new(),Sword.new()]
onready var invmodels: Array = []
var inventoryindex: int

enum state {WALK,ROLL}
var currentstate

var RollTimer: Timer

var rolltime = 0.2
var rollcooldown = 0.5 
var speed = 30

onready var ModelBase = $Model/Viewport/model/base

func damage(amount):
	$ui/health.text = str(CurrentHealth)
	.damage(amount)

func swap_weapon():
	var currentweaponmodel = $Model/Viewport/model/base/weapon
	ModelBase.remove_child(currentweaponmodel)
	ModelBase.add_child(invmodels[inventoryindex])
	inventory[inventoryindex].getAnim()

func _roll():
	if RollTimer.time_left > 0:
		return
	currentstate = state.ROLL
	get_tree().call_group("enemies","nocollide_player")
	yield(get_tree().create_timer(rolltime),"timeout")
	get_tree().call_group("enemies","collide_player")
	currentstate = state.WALK
	RollTimer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	damage(0)
	
	
	RollTimer = Timer.new()
	RollTimer.wait_time = rollcooldown
	RollTimer.one_shot = true
	add_child(RollTimer)
	
	currentstate = state.WALK
	get_node("/root/GlobalPlayer").set_player(self)
	movementVector = Vector2(0,0)
	camera = $Camera2D
	inventoryindex = 0
	
	for n in range(0,inventory.size()):
		add_child(inventory[n])
		invmodels.append(inventory[n].ModelScene.instance())
		
	swap_weapon()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_LEFT:
					if currentstate != state.ROLL:
						inventory[inventoryindex].shoot()
				BUTTON_WHEEL_UP:
					if inventoryindex >0:
						inventoryindex-=1
					else:
						inventoryindex = inventory.size() -1
					swap_weapon()
				BUTTON_WHEEL_DOWN:
					if inventoryindex < inventory.size()-1:
						inventoryindex += 1
					else:
						inventoryindex = 0
					swap_weapon()
func _process(delta):
	if currentstate != state.ROLL:
		movementVector = Vector2()
		if Input.is_key_pressed(KEY_W):
			movementVector.y -= 0.5
		if Input.is_key_pressed(KEY_S):
			movementVector.y += 0.5
		if Input.is_key_pressed(KEY_A):
			movementVector.x -= 1
		if Input.is_key_pressed(KEY_D):
			movementVector.x += 1
		movementVector = movementVector.normalized()*speed
		if Input.is_key_pressed(KEY_SHIFT):
			_roll()
		
	match currentstate:
		state.WALK:
			ModelBase.rotation.y = -get_angle_to(get_global_mouse_position())

func _physics_process(delta):
	match currentstate:
		state.WALK:
			move_and_slide(movementVector*10)
		state.ROLL:
			move_and_slide(movementVector*30)

func die():
	get_tree().call_group("enemies", "queue_free")
	print("player die")
	for n in range(0,inventory.size()):
		inventory[n].queue_free()
		invmodels[n].queue_free()
	.die()
