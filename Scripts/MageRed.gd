extends Character

enum HorizontalDirection {
	Left,
	Right
}

# Asset references
export(PackedScene) var fireball_prefab

# Child references
onready var timer = $Timer as Timer
onready var fireball_spawn_point = $FireballSpawnPoint as Node2D

# Parameter
export(float) var initial_fireball_delay = 1.0
export(float) var fireball_interval = 2.0
export(float) var fireball_speed = 200.0

func _ready():
	var _error
	_error = GameManager.connect("setup_mission", self, "on_mission_setup")
	_error = GameManager.connect("run_mission", self, "on_mission_run")
	_error = GameManager.connect("succeed_mission", self, "on_mission_succeed")
	_error = GameManager.connect("fail_mission", self, "on_mission_failed")

func on_mission_setup():
	pass

func on_mission_run():
	timer.start(initial_fireball_delay)

func on_mission_succeed():
	timer.stop()

func on_mission_failed():
	timer.stop()

func _on_Timer_timeout():
	shoot_fireball()
	
	# timer is one-shot, so we restart it manually (allows us to use different
	# interval than initial delay)
	timer.start(fireball_interval)

# Input

func _on_ClickArea2D_input_event(_viewport, event, _shape_idx):
	# during setup only, click to change direction
	if event.is_action_pressed("mouse_interact"):
		if GameManager.phase == GameManager.Phase.Setup:
			mirror_direction()

# Setup
func mirror_direction():
	scale.x *= -1

# Behavior

func get_direction_vector():
	return Vector2.LEFT if scale.x > 0 else Vector2.RIGHT

func shoot_fireball():
	# spawn fireball in Mission scene root (not global root)
	# so fireball gets removed when changing/reloading level
	var fireball = fireball_prefab.instance()
	owner.add_child(fireball)
	var fireball_velocity = fireball_speed * get_direction_vector()
	fireball.setup(fireball_spawn_point.global_position, fireball_velocity)

func die():
	queue_free()
