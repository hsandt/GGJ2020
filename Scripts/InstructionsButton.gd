extends Button

export(NodePath) var instructions_panel

func _on_Instructions_Button_pressed():
	get_node(self.instructions_panel).show()
