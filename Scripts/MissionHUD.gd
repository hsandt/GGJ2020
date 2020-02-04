extends CanvasLayer

export(NodePath) var title_path

var title_label : Label

onready var success_label = $Success
onready var failure_label = $Failure
onready var run_button = $HBoxContainer/RunButton
onready var retry_button = $HBoxContainer/RetryButton
onready var next_mission_button = $HBoxContainer/NextMissionButton
onready var back_to_tile_button = $HBoxContainer/BackToTitleButton

func _ready():
	var _error
	_error = GameManager.connect("setup_mission", self, "on_mission_setup")
	_error = GameManager.connect("run_mission", self, "on_mission_run")
	_error = GameManager.connect("succeed_mission", self, "on_mission_succeed")
	_error = GameManager.connect("fail_mission", self, "on_mission_failed")
	
	title_label = get_node(self.title_path) as Label
	assert(title_label)
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
	success_label.hide()
	failure_label.hide()
	run_button.show()
	retry_button.hide()
	next_mission_button.hide()
	next_mission_button.show()

func on_mission_run():
	success_label.hide()
	failure_label.hide()
	run_button.hide()
	retry_button.show()
	next_mission_button.hide()
	next_mission_button.show()

func on_mission_succeed():
	success_label.show()
	failure_label.hide()
	run_button.hide()
	retry_button.show()
	next_mission_button.show()
	next_mission_button.show()

func on_mission_failed():
	success_label.hide()
	failure_label.show()
	run_button.hide()
	retry_button.show()
	next_mission_button.hide()
	next_mission_button.show()
