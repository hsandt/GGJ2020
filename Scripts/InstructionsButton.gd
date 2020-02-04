extends Button

export(NodePath) var instructions_panel_path

var instructions_panel : Control

func _ready():
	instructions_panel = get_node(self.instructions_panel_path) as Control
	assert(instructions_panel)

func _on_Instructions_Button_pressed():
	instructions_panel.show()
