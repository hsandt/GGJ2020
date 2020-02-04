extends Control

export(NodePath) var instructions_panel_path

var instructions_panel : Control

func _ready():
	# hide any panel that should not be visible on start
	# (in case we were keeping them visible in editor for editing)
	instructions_panel = get_node(self.instructions_panel_path) as Control
	assert(instructions_panel)
	
	if instructions_panel:
		instructions_panel.hide()
