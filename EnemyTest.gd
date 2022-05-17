extends Enemy

func _ready():
	currentstate = AIState.STATE_PATROL
	._ready()

func _aistate_mouse():
	if(path.size() > 0):
		var heading = (path[currentPointIndex] - global_position).normalized()
		move_and_slide(heading*5*Speed)
		if global_position.distance_to(path[currentPointIndex]) < $CollisionShape2D.shape.radius && currentPointIndex<path.size()-1:
			currentPointIndex += 1
			
func _aistate_patrol():
	pass

