extends Damageable

class_name Enemy

export var NavNode:NodePath
export var LineNode:NodePath

onready var Nav:Navigation2D = get_node(NavNode)
onready var Line:Line2D = get_node(LineNode)
var Target:Damageable

var path: PoolVector2Array
var pathindex: int

export var Speed:float
export var BaseDamage:int
export var AttackRange:float
export var ChaseRange:float

var AIStateMachine = StateMachine.new()
var IdleState = State.new()
var AttackState = State.new()
var ChaseState = State.new()

onready var globalplayer = get_node("/root/GlobalPlayer").get_player()

func _attack():
	pass

var currentPointIndex = 0

var heading: Vector2

func _aistate_idle_begin():
	pass
func _aistate_idle_update():
	if Target != null:
		if Target.global_position.distance_to(global_position) <= ChaseRange:
			AIStateMachine.change_state(ChaseState)
func _aistate_idle_end():
	pass
 
func _aistate_attack_begin():
	pass
func _aistate_attack_update():
	if Target != null:
		_attack()
		if Target.global_position.distance_to(global_position) > AttackRange &&  Target.global_position.distance_to(global_position) <= ChaseRange:
			AIStateMachine.change_state(ChaseState)
func _aistate_attack_end():
	pass

func _aistate_chase_begin():
	if Target != null:
		var p = Nav.get_simple_path(global_position,Target.global_position,false)
		path = p
		Line.points = path
func _aistate_chase_update():
	if Target != null:
		if Target.global_position.distance_to(global_position) <= AttackRange :
			AIStateMachine.change_state(AttackState)
		if global_position.distance_to(path[pathindex]) < $CollisionShape2D.shape.radius && pathindex < path.size():
			pathindex = 1
			var p = Nav.get_simple_path(global_position,Target.global_position,false)
			path = p
			Line.points = path
		heading = global_position.direction_to(path[pathindex])
		move_and_slide(heading*Speed*5)
		
func _aistate_chase_end():
	pass

func _ready():
	add_to_group("enemies")
	
	if !is_connected("damaged",self,"_on_EnemyBody_damaged"):
		connect("damaged",self,"_on_EnemyBody_damaged")
	
	pathindex = 0
	
	AttackRange *= 10
	ChaseRange *= 10
	
	IdleState.init(self,"_aistate_idle_begin","_aistate_idle_update","_aistate_idle_end")
	ChaseState.init(self,"_aistate_chase_begin","_aistate_chase_update","_aistate_chase_end")
	AttackState.init(self,"_aistate_attack_begin","_aistate_attack_update","_aistate_attack_end")
	
	Target = globalplayer
	
	AIStateMachine.change_state(IdleState)

func _process(delta):
	if is_instance_valid(Target):
		if !Target.is_inside_tree():
			Target = globalplayer
	elif !is_instance_valid(Target):
		Target = globalplayer
	if  !is_instance_valid(globalplayer):
		get_parent().remove_child(self)
	elif !globalplayer.is_inside_tree():
		get_parent().remove_child(self)

func _physics_process(_delta):
	AIStateMachine.update_state()

func set_target(object):
	Target = object

func _on_EnemyBody_damaged():
	AIStateMachine.change_state(ChaseState)

func nocollide_player():
	add_collision_exception_with(globalplayer)

func collide_player():
	remove_collision_exception_with(globalplayer)
	
func die():
	if IdleState != null:
		IdleState.destroy()
	if AttackState != null:
		AttackState.destroy()
	if ChaseState != null:
		ChaseState.destroy()
	.die()
