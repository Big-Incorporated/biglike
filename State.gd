extends Node

class_name State

var begin_state:FuncRef
var update_state:FuncRef
var exit_state:FuncRef

func _state_begin():
	if begin_state != null:
		if begin_state.is_valid():
			begin_state.call_func()
	emit_signal("state_begin",self)
func _state_update():
	if begin_state != null:
		if begin_state.is_valid():
			update_state.call_func()
func _state_exit():
	if begin_state != null:
		if begin_state.is_valid():
			exit_state.call_func()
	emit_signal("state_exit",self)
