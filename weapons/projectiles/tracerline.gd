extends Line2D

class_name TracerLine

var timeout = 1.0

func trace(startpos,endpos):
	add_point(startpos)
	add_point(endpos)
	yield(get_tree().create_timer(timeout), "timeout")
	get_tree().root.remove_child(self)
	queue_free()
