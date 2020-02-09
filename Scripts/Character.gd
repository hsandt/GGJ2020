extends Node2D
class_name Character

func _ready():
	var _error
	_error = GameManager.connect("setup_mission", self, "on_mission_setup")
	_error = GameManager.connect("run_mission", self, "on_mission_run")
	_error = GameManager.connect("succeed_mission", self, "on_mission_stop_with_success")
	_error = GameManager.connect("fail_mission", self, "on_mission_stop_with_failure")

# virtual
func on_mission_setup():
	pass

# virtual
func on_mission_run():
	pass

func on_mission_succeed_and_stop():
	on_mission_stop()
	on_mission_succeed()

func on_mission_stop_with_failure():
	on_mission_stop()
	on_mission_failed()

# virtual (convenient for behavior common to success and failure)
func on_mission_stop():
	pass

# virtual
func on_mission_succeed():
	pass

# virtual
func on_mission_failed():
	pass

func _on_HurtBox_body_entered(body):
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
	fireball.destroy()
	die()

func on_chandelier_collision(_chandelier_body):
	# collision with fireball detected, kill this character
	# (but chandelier remains)
	die()

func die():
	pass
