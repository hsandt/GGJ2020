extends Character

func on_mission_setup():
	GameManager.living_bosses_count += 1
	print("total boss: " + str(GameManager.living_bosses_count))

func die():
	queue_free()
	GameManager.living_bosses_count -= 1
	print("total boss: " + str(GameManager.living_bosses_count))
