extends Enemy

class_name Shotgunner

func _ready():
	$Shotgun.getAnim()

func _attack():
	$Shotgun.shoot()

