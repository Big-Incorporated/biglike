extends Projectile

var speed = 500

func _process(delta):
	global_position += (Vector2(cos(global_rotation),sin(global_rotation)) * delta * speed)
	var hit = get_overlapping_bodies()
	for body in hit:
		if body != Parent:
			if body is Damageable:
				body.damage(1)
			queue_free()
