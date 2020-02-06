extends Area2D

func _on_Area2D_body_entered(body):
	var fireball = body as Fireball
	if fireball:
		fireball.destroy()
		print("fireball dies in dead zone")
		
	var chandelier_body = body as ChandelierBody
	if chandelier_body:
		chandelier_body.destroy()
		print("chandelier_body dies in dead zone")
