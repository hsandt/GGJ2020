extends Button

export(PackedScene) var mission_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Mission_Button_pressed():
	get_tree().change_scene_to(mission_scene)
