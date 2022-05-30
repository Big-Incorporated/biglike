extends Node

class_name State

var begin_state:FuncRef
var update_state:FuncRef
var exit_state:FuncRef

signal state_begin
signal state_exit

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

func init(object,func1,func2,func3):
	begin_state = funcref(object,func1)
	update_state = funcref(object,func2)
	exit_state = funcref(object,func3)
