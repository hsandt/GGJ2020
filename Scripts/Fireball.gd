extends KinematicBody2D
class_name Fireball

# Parameter
var velocity : Vector2

func setup(position, setup_velocity):
	self.position = position
	self.velocity = setup_velocity

func _process(delta):
	var kinematic_collision2d = move_and_collide(self.velocity * delta)
	if kinematic_collision2d:
		if kinematic_collision2d.collider is WhiteBarrier:
			# bounce direction is opposite of reflected incoming direction
			self.velocity = -self.velocity.reflect(kinematic_collision2d.normal)

func destroy():
	# finally decrement active count, as task transferred from MageRed is over
	GameManager.decrement_active_elements_count()
	print("fireball died: " + str(GameManager.active_elements_count))
	queue_free()
