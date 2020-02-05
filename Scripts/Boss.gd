extends Character

func die():
	queue_free()

	# boss has been defeated, so player wins this mission
	GameManager.succeed_mission()
