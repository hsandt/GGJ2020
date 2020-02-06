extends Character

func die():
	queue_free()
	GameManager.dead_princesses_count += 1
	print("total princesses dead: " + str(GameManager.dead_princesses_count))
