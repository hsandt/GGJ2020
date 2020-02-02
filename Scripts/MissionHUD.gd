extends Control

export(NodePath) var title

func _ready():
	# DEBUG: when debugging by starting in MissionHUD scene, current mission is 0
	# so set something meaningful to avoid errors (there is no level though,
	# so you won't be able to test everything as in the real game)
	if GameManager.current_mission_number == 0:
		GameManager.current_mission_number = 1
		GameManager.phase = GameManager.Phase.Setup
	# END DEBUG
	
	var _error
	_error = GameManager.connect("setup_mission", self, "on_mission_setup")
	_error = GameManager.connect("run_mission", self, "on_mission_run")
	_error = GameManager.connect("succeed_mission", self, "on_mission_succeed")
	_error = GameManager.connect("fail_mission", self, "on_mission_failed")
		
	var title_label = get_node(self.title) as Label
	if title_label:
		title_label.text = "Mission %02d" % GameManager.current_mission_number

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
