extends Node2D

func _on_Area2D_body_entered(body):
	var fireball = body as Fireball
	if fireball:
		# collision with fireball detected, destroy both entities
		fireball.queue_free()
		queue_free()
		
		# princess has been defeated, so player loses this mission
		GameManager.fail_mission()
