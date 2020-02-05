extends Node2D
class_name Character

func _on_Area2D_body_entered(body):
	var fireball = body as Fireball
	if fireball:
		on_fireball_collision(fireball)
		return
	
	var chandelier_body = body as ChandelierBody
	if chandelier_body:
		on_chandelier_collision(chandelier_body)
		return
		
func on_fireball_collision(fireball):
	# collision with fireball detected, destroy both entities
	fireball.queue_free()
	die()

func on_chandelier_collision(chandelier_body):
	# collision with fireball detected, kill this character
	# (but chandelier remains)
	die()

func die():
	pass
