extends KinematicBody2D

export var BaseSpeed:float
export var BaseDamage:int
export var MaxHealth:int

var health:int = MaxHealth

var movementVector:Vector2;

# Called when the node enters the scene tree for the first time.
func _ready():
	movementVector = Vector2(0,0);
	pass # Replace with function body.



func _process(delta):
	if(Input.is_key_pressed(KEY_W)):
		movementVector.y = -5;
	elif(Input.is_key_pressed(KEY_S)):
		movementVector.y = 5;
	elif(!Input.is_key_pressed(KEY_W) && !Input.is_key_pressed(KEY_S)):
		movementVector.y = 0;
	if(Input.is_key_pressed(KEY_D)):
		movementVector.x = 5;
	elif(Input.is_key_pressed(KEY_A)):
		movementVector.x = -5;
	elif(!Input.is_key_pressed(KEY_A) && !Input.is_key_pressed(KEY_D)):
		movementVector.x = 0;

func _physics_process(delta):
	move_and_slide(movementVector*BaseSpeed)
