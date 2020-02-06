extends CanvasLayer

export(NodePath) var title_path

onready var mission_scene = owner as MissionScene
onready var title_label = $Title as Label
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
	
	if mission_scene:
		title_label.text = "Mission %02d" % mission_scene.mission_number
		# DEBUG
		# When debugging by starting in Mission scene (F6), current mission is 0
		# so setup mission with number provided by scene root script (no need to start,
		# as mission scene is already loaded).
		# This must be done after connecting signals so setup_mission comes back to us,
		# hence call_deferred
		if GameManager.current_mission_number == 0:
			call_deferred("debug_setup_mission")
		# END DEBUG
	else:
		print("WARNING: cannot set Mission Title label. Are you playing in the Mission HUD scene?")

# DEBUG
func debug_setup_mission():
	GameManager.current_mission_number = mission_scene.mission_number
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
