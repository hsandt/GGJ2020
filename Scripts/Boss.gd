extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_entered(body):
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
	fireball.queue_free()
	die()

func on_chandelier_collision(chandelier_body):
	# collision with fireball detected, kill boss
	# (but chandelier remains)
	die()

func die():
	queue_free()

	# boss has been defeated, so player wins this mission
	GameManager.succeed_mission()
