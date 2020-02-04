extends Node2D

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

# Deduced by scale x / fireball spawn point position relative to center
var direction : int  # HorizontalDirection

func _ready():
	var _error
	_error = GameManager.connect("setup_mission", self, "on_mission_setup")
	_error = GameManager.connect("run_mission", self, "on_mission_run")
	_error = GameManager.connect("succeed_mission", self, "on_mission_succeed")
	_error = GameManager.connect("fail_mission", self, "on_mission_failed")

	self.direction = HorizontalDirection.Left if scale.x > 0 else HorizontalDirection.Right

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

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("mouse_interact"):
		print(event.global_position)

# Behavior

func shoot_fireball():
	# spawn fireball in Mission scene root (not global root)
	# so fireball gets removed when changing/reloading level
	var fireball = fireball_prefab.instance()
	owner.add_child(fireball)
	var velocity_dir = Vector2.LEFT if direction == HorizontalDirection.Left else Vector2.RIGHT
	var fireball_velocity = fireball_speed * velocity_dir
	fireball.setup(fireball_spawn_point.global_position, fireball_velocity)
