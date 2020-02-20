extends Character

enum HorizontalDirection {
	Left,
	Right
}

# Asset references
export(PackedScene) var fireball_prefab

# Child references
onready var timer = $Timer as Timer
onready var body = $Body as Node2D
onready var fireball_spawn_point = $Body/FireballSpawnPoint as Node2D
onready var delay_slider = $DelaySlider as HSlider

# Parameter
export(float) var fireball_speed = 200.0

func on_mission_run():
	# Consider MageRed active until he shot his fireball
	GameManager.active_elements_count += 1
	print("total: " + str(GameManager.active_elements_count))
	
	var initial_fireball_delay = delay_slider.value
	
	# 0 is not accepted as wait_time, so put something very small
	# (smaller than 1/60 to trigger event next frame)
	if initial_fireball_delay == 0.0:
		initial_fireball_delay = 0.01
	timer.start(initial_fireball_delay)

func on_mission_stop():
	timer.stop()

func _on_Timer_timeout():
	shoot_fireball()

# Input

func _on_ClickArea2D_input_event(_viewport, event, _shape_idx):
	# during setup only, click to change direction
	if event.is_action_pressed("mouse_interact"):
		if GameManager.phase == GameManager.Phase.Setup:
			mirror_direction()

# Setup
func mirror_direction():
	body.scale.x *= -1

# Behavior

func get_direction_vector():
	return Vector2.LEFT if body.scale.x > 0 else Vector2.RIGHT

func shoot_fireball():
	# spawn fireball in Mission scene root (not global root)
	# so fireball gets removed when changing/reloading level
	# note that we do not change GameManager.active_elements_count:
	# indeed, we would decrement it as MageRed has fulfilled his task,
	# but re-increment it as the fireball is a new running task (task transfer)
	var fireball = fireball_prefab.instance()
	owner.add_child(fireball)
	var fireball_velocity = fireball_speed * get_direction_vector()
	fireball.setup(fireball_spawn_point.global_position, fireball_velocity)

func die():
	# only decrement active count if about to shoot fireball
	# (timer still running), as mage still owns the task at this point
	if not timer.is_stopped():
		GameManager.on_active_element_destroyed()
		print("Red Mage died before shooting: " + str(GameManager.active_elements_count))
	queue_free()
