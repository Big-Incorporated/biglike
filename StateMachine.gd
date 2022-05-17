extends Node

class_name StateMachine

var current_state:State setget change_state, get_state

var should_state_update = false

func change_state(new_state:State):
	should_state_update = false
	if current_state != null:
		current_state._state_exit()
	current_state = new_state
	if current_state != null:
		current_state._state_begin()
	should_state_update = true
	 
func get_state():
	return current_state
	
func update_state():
	if current_state != null:
		if should_state_update == true:
			current_state._state_update()
