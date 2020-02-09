extends Character

onready var white_barrier_handle = $WhiteBarrierHandle as Area2D
onready var white_barrier = $WhiteBarrier as StaticBody2D

# Computed on ready (expression was too complex for a one-line onready var)
var base_shape_radius : float

# Parameters
export var initial_barrier_radius = 100.0
export var min_barrier_radius = 50.0
export var max_barrier_radius = 150.0

# State

# Input
var moving_barrier_handle = false

# Run parameters (modified by player during Setup)
var barrier_radius : float

func _ready():
	var shape_node = $WhiteBarrier/CollisionShape2D as CollisionShape2D
	var shape = shape_node.shape as CircleShape2D
	if shape:
		base_shape_radius = shape.radius
	else:
		print("ERROR: WhiteBarrier shape is not CircleShape2D, cannot get radius")

	set_barrier_radius(initial_barrier_radius)

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
				var distance = white_barrier.global_position.distance_to(event.position)
				var new_radius = clamp(distance, min_barrier_radius, max_barrier_radius)
				set_barrier_radius(new_radius)
			if event.is_action_released("mouse_interact"):
					self.moving_barrier_handle = false

func set_barrier_radius(value):
	self.barrier_radius = value
	var scale = value / base_shape_radius
	self.white_barrier.scale = Vector2(scale, scale)
	self.white_barrier_handle.position = value * Vector2.RIGHT

func on_mission_run():
	# stop editing now, but preserve last value
	# (note that this can only happen if you hold the mouse button
	# while running the Mission with some keyboard shortcut)
	self.moving_barrier_handle = false

func die():
	queue_free()
