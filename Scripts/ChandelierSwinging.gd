extends Node2D
class_name ChandelierSwinging

onready var swing_pivot = $SwingPivot as Node2D
onready var chandelier_body = $SwingPivot/ChandelierBody as RigidBody2D
onready var chandelier_body_shape = $SwingPivot/ChandelierBody/CollisionShape2D as CollisionShape2D

# Parameters
export(float) var swing_max_angle = 10.0  # degrees
export(float) var swing_period = 5.0      # sec

# State
var is_body_detached = false
var swing_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	# cos is periodic so modulo is optional, just to avoid big numbers
	swing_time = fmod(swing_time + delta, swing_period)
	swing_pivot.rotation_degrees = swing_max_angle * cos(TAU * swing_time / swing_period)

func _on_BreakableLink_body_entered(body):
	var fireball = body as Fireball
	if fireball and not is_body_detached:
		# collision with fireball detected, destroy it
		fireball.destroy()
		
		# detach chandelier body so it can fall
		self.is_body_detached = true
		
		# Consider Chandelier body active until it hits the ground (or deadzone)
		# We are doing this *after* fireball destroy which may have already decremented
		#   the count to 0, but this is OK as we defer GameManager count check to next frame
		# We shouldn't increment the count in the call_deferred below, though, as it may
		# be later than the count check so the mission would end just as the chandelier body
		# starts falling. 
		GameManager.active_elements_count += 1
		print("chandelier detached! total active: " + str(GameManager.active_elements_count))
		
		call_deferred("detach_chandelier_body")

func detach_chandelier_body():
	var pos = chandelier_body.global_position
	var rot = chandelier_body.global_rotation
	print(chandelier_body.angular_velocity)  # restore global rotation 
	
	# keep chandelier_body in Mission scene root (not global root)
	# so it gets removed when changing/reloading level
	swing_pivot.remove_child(chandelier_body)
	owner.add_child(chandelier_body)
	
	# as a hack, we set Rigidbody2D mode to STATIC
	# in the editor to disable physics as long as the body
	# was parented to the chain, to avoid physics simulation
	# adding a small offset from the chain tip on mission start
	# (not correct as STATIC should be static in the world,
	# not under parent, but it works, just like KINEMATIC, and it's
	# simpler than creating a dummy Chandelier Body with just a sprite
	# and spawning another version with a Rigidbody2D on detach)
	# so we need to set it to RIGID now to start physics simulation
	chandelier_body.mode = RigidBody2D.MODE_RIGID
	# we also disabled Shape in the editor to avoid killing
	# characters during the setup phase (should not happen as Chandeliers
	# should be far from them, but safer), so we reenable it now
	chandelier_body_shape.disabled = false

	# restore global position and rotation for continuity on detach
	chandelier_body.position = pos
	chandelier_body.rotation = rot
	
	# we also want to restore velocities,
	# but unfortunately, physics simulation was not active so the previous
	# linear/angular velocities were zero
	# so we need to compute them manually with a math formula for radial motion:
	# linear velocity = r * theta-dot * e_theta
	# angular velocity = theta-dot
	
	var radius = pos.distance_to(swing_pivot.global_position)
	
	# to get theta-dot, derive the expression of swing_pivot.rotation_degrees by swing_time:
	# swing_pivot.rotation_degrees = swing_max_angle * cos(TAU * swing_time / swing_period)
	var angular_speed_deg = - swing_max_angle * sin(TAU * swing_time / swing_period)
	var angular_speed_rad = deg2rad(angular_speed_deg)
	
	# to get e_theta unit vector, rotate e_r radial vector by 90 deg (or derive e_r to get theta-dot * e_theta directly)
	# make sure to use angles in radians
	# e_r = (-sin(swing_pivot.rotation), cos(swing_pivot.rotation))
	# e_theta = (-cos(swing_pivot.rotation), -sin(swing_pivot.rotation))
	var last_velocity_dir = Vector2(-cos(swing_pivot.rotation), sin(swing_pivot.rotation))
	var last_velocity = radius * angular_speed_rad * last_velocity_dir
	chandelier_body.linear_velocity = last_velocity  # restore linear velocity

	var last_angular_velocity = angular_speed_rad
	chandelier_body.angular_velocity = last_angular_velocity  # restore angular velocity
