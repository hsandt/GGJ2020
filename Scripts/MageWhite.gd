extends Character

onready var white_barrier_handle = $WhiteBarrierHandle as Area2D
onready var white_barrier = $WhiteBarrier as StaticBody2D

# Computed on ready (expression was too complex for a one-line onready var)
var barrier_handle_distance : float

# State

# Input
var moving_barrier_handle = false

# Run parameters (modified by player during Setup)
var barrier_radius : float

func _ready():
	barrier_handle_distance = white_barrier_handle.position.length()
		
	# seems redundant, but it's just to update handle position in case it doesn't match on start
	set_barrier_angle(white_barrier.rotation)

func _on_WhiteBarrierHandle_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	# detect player clicking on handle to start moving it
	if event.is_action_pressed("mouse_interact"):
		if GameManager.phase == GameManager.Phase.Setup:
			var mouse_event = event as InputEventMouseButton
			if mouse_event:
					self.moving_barrier_handle = true
			else:
				print("ERROR: mouse_interact input event is not an InputEventMouseButton, " +
					"make sure only mouse buttons are mapped to this action")

func _unhandled_input(event: InputEvent):
	# mouse may be released outside handle area, so we need the generic
	# input method to detect it
	if self.moving_barrier_handle:
		if GameManager.phase == GameManager.Phase.Setup:
			if event is InputEventMouseMotion:
				# we assume the handle is not too big and we don't need to subtract
				# the initial drag offset
				var center_to_mouse_vector : Vector2 = event.position - white_barrier.global_position
				var angle = Vector2.UP.angle_to(center_to_mouse_vector)
				set_barrier_angle(angle)
			if event.is_action_released("mouse_interact"):
					self.moving_barrier_handle = false

func set_barrier_angle(value):
	white_barrier.rotation = value
	# white barrier and handle have same parent (MageWhite), so just set relative position
	white_barrier_handle.position = white_barrier.position + self.barrier_handle_distance * Vector2.UP.rotated(value)

func on_mission_run():
	# stop editing now, but preserve last value
	# (note that this can only happen if you hold the mouse button
	# while running the Mission with some keyboard shortcut)
	self.moving_barrier_handle = false

func die():
	queue_free()
