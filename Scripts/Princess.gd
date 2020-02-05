extends Character

func die():
	queue_free()
	
	# princess has been defeated, so player loses this mission
	GameManager.fail_mission()
