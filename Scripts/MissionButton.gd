extends Button

export(int) var mission_number

func _on_Mission_Button_pressed():
	GameManager.start_mission(self.mission_number)
