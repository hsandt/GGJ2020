extends Button

export(PackedScene) var mission_scene

func _on_Mission_Button_pressed():
	get_tree().change_scene_to(mission_scene)
