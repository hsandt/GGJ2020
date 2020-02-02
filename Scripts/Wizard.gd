extends Node2D

onready var timer = $Timer as Timer

func _ready():
	var _error
	_error = GameManager.connect("setup_mission", self, "on_mission_setup")
	_error = GameManager.connect("run_mission", self, "on_mission_run")
	_error = GameManager.connect("succeed_mission", self, "on_mission_succeed")
	_error = GameManager.connect("fail_mission", self, "on_mission_failed")

func on_mission_setup():
	pass

func on_mission_run():
	timer.start()

func on_mission_succeed():
	timer.stop()

func on_mission_failed():
	pass

func _on_Timer_timeout():
	shoot_fireball()
	
func shoot_fireball():
	print("FIREBALL!!")
	# cheat
	GameManager.succeed_mission()
