extends Control

export(NodePath) var instructions_panel

func _ready():
	# hide any panel that should not be visible on start
	# (in case we were keeping them visible in editor for editing)
	get_node(instructions_panel).hide()
