extends Control

export(NodePath) var title

func _ready():
	var _error
	_error = GameManager.connect("setup_mission", self, "on_mission_setup")
	_error = GameManager.connect("run_mission", self, "on_mission_run")
	_error = GameManager.connect("succeed_mission", self, "on_mission_succeed")
	_error = GameManager.connect("fail_mission", self, "on_mission_failed")
	
	var title_label = get_node(self.title) as Label
	if title_label:
		title_label.text = "Mission %02d" % GameManager.current_mission_number
		
	# DEBUG: when debugging by starting in MissionHUD scene, current mission is 0
	# so setup something meaningful to avoid errors (there is no level though,
	# so you won't be able to test everything as in the real game)
	# must be done after connecting signals so setup_mission comes back to us
	if GameManager.current_mission_number == 0:
		GameManager.current_mission_number = 1
		GameManager.setup_mission()
	# END DEBUG

func on_mission_setup():
	$Success.hide()
	$HBoxContainer/RunButton.show()
	$HBoxContainer/RetryButton.show()
	$HBoxContainer/NextMissionButton.hide()
	$HBoxContainer/BackToTitleButton.show()
	
func on_mission_run():
	$Success.hide()
	$HBoxContainer/RunButton.hide()
	$HBoxContainer/RetryButton.show()
	$HBoxContainer/NextMissionButton.hide()
	$HBoxContainer/BackToTitleButton.show()

func on_mission_succeed():
	$Success.show()
	$HBoxContainer/RunButton.hide()
	$HBoxContainer/RetryButton.show()
	$HBoxContainer/NextMissionButton.show()
	$HBoxContainer/BackToTitleButton.show()

func on_mission_failed():
	$Success.hide()
	$HBoxContainer/RunButton.hide()
	$HBoxContainer/RetryButton.show()
	$HBoxContainer/NextMissionButton.hide()
	$HBoxContainer/BackToTitleButton.show()
