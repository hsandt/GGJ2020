extends KinematicBody2D
class_name Fireball

onready var shape = $CollisionShape2D as CollisionShape2D

# Setup parameter
var velocity : Vector2

func setup(position, setup_velocity):
	self.position = position
	self.velocity = setup_velocity
	
	# prevent killing character shooting this fireball / being blocked on spawn
	shape.disabled = true

func _on_Timer_timeout():
	# after short time, re-enable collider
	shape.disabled = false

func _process(delta):
	var kinematic_collision2d = move_and_collide(self.velocity * delta)
	if kinematic_collision2d:
		if kinematic_collision2d.collider is WhiteBarrier:
			# bounce direction is opposite of reflected incoming direction
			self.velocity = -self.velocity.reflect(kinematic_collision2d.normal)

func destroy():
	# finally decrement active count, as task transferred from MageRed is over
	GameManager.on_active_element_destroyed()
	print("fireball died: " + str(GameManager.active_elements_count))
	queue_free()
