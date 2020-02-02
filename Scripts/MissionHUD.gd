extends Control

export(NodePath) var title

func _ready():
	var title_label = get_node(self.title) as Label
	if title_label:
		title_label.text = "Mission %02d" % GameManager.current_mission_number
