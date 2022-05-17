extends KinematicBody2D

class_name Enemy

export var NavNode:NodePath
export var LineNode:NodePath
export var PlayerNode:NodePath

export(Array,NodePath) var PatrolPointNodes

onready var Nav:Navigation2D = get_node(str(NavNode))
onready var Line:Line2D = get_node(str(LineNode))
onready var Player:KinematicBody2D = get_node(str(PlayerNode))

var PatrolPoints:Array
var path: PoolVector2Array

var LineofSight:RayCast2D = RayCast2D.new()

export var MaxHealth:int
export var Speed:float
export var BaseDamage:int
export var MaxVisionDistance:float

var playerwithinrange:bool = false

var currentPointIndex = 0
	
var currentpatrolpoint = 0

func _aistate_mouse_update():
	if currentPointIndex == 0:
		Nav.get_simple_path(global_position, get_global_mouse_position())

func _aistate_patrol_begin():
	currentPointIndex = 0
	var closestpoint:Node2D = PatrolPoints[0]
	for x in range(0, PatrolPoints.size()-1):
		if PatrolPoints[x].global_position.distance_to(global_position) < closestpoint.global_position.distance_to(global_position):
			closestpoint = PatrolPoints[x]
			currentpatrolpoint = x
	var path_to_point = Nav.get_simple_path(global_position,closestpoint.global_position)
	if path_to_point.size() > 0:
		path = path_to_point
	print("patrol begun")

func _aistate_patrol_update():
	var path_to_point:PoolVector2Array
	if global_position.distance_to(PatrolPoints[currentpatrolpoint].global_position) < $CollisionShape2D.shape.radius:
		if currentpatrolpoint < PatrolPoints.size()-1:
			currentPointIndex = 0
			currentpatrolpoint += 1
			print(currentpatrolpoint)
		elif currentpatrolpoint >= PatrolPoints.size()-1:
			currentPointIndex = 0
			print("return to 0")
			currentpatrolpoint = 0
		path_to_point = Nav.get_simple_path(global_position,PatrolPoints[currentpatrolpoint].global_position,false)
		if path_to_point.size() > 0:
			path = path_to_point
		Line.points = path
		
func _aistate_patrol_end():
	currentPointIndex = 0
	path.empty()
	
func _aistate_attack_begin():
	pass
func _aistate_attack_update():
	pass
func _aistate_attack_end():
	currentPointIndex = 0
	path.empty()

var AIStateMachine = StateMachine.new()
var PatrolState:State = State.new()
var AttackState:State = State.new()
var SearchState:State = State.new()

func _ready():
	LineofSight.add_exception(self)
	
	var VisionShape = get_node("VisionArea/CollisionShape2D")
	VisionShape.shape.radius = MaxVisionDistance

	for path in PatrolPointNodes:
		PatrolPoints.append(get_node(path))
	PatrolState.begin_state = funcref(self,"_aistate_patrol_begin")
	PatrolState.update_state = funcref(self,"_aistate_patrol_update")
	PatrolState.exit_state = funcref(self,"_aistate_patrol_end")
	AIStateMachine.change_state(PatrolState)

func _process(delta):
	AIStateMachine.update_state()
	if(path.size() > 0):
		var heading = (path[currentPointIndex] - global_position).normalized()
		move_and_slide(heading*5*Speed)
		if global_position.distance_to(path[currentPointIndex]) < $CollisionShape2D.shape.radius && currentPointIndex<path.size()-1:
			currentPointIndex += 1


func _on_VisionArea_body_entered(body):
	if body == Player:
		playerwithinrange = true
		print("player visible")


func _on_VisionArea_body_exited(body):
	if body == Player:
		playerwithinrange = false
		print("player out of range")
