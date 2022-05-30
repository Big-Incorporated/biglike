extends Area2D

func _ready():
	if !is_connected("body_entered",get_node("../../EnemyBody"),"_on_AttackArea_body_entered"):
		connect("body_entered",get_node("../../EnemyBody"),"_on_AttackArea_body_entered")
	if !is_connected("body_exited", get_node("../../EnemyBody"),"_on_AttackArea_body_exited"):
		connect("body_exited", get_node("../../EnemyBody"),"_on_AttackArea_body_exited")
