extends Node

enum Phase {
	Setup,
	Run,
	Success,
	Failure
}

const MAX_MISSION_NUMBER = 2

signal setup_mission
signal run_mission
signal succeed_mission
signal fail_mission

var current_mission_number : int
var phase : int  # Phase

func go_to_title():
	var error = get_tree().change_scene("res://Scenes/Title.tscn")
	if error:
		print("error: " + str(error))

func start_mission(mission_number):
	self.current_mission_number = mission_number
	var error = get_tree().change_scene("res://Scenes/Mission%02d.tscn" % mission_number)
	if error:
		print("error: " + str(error))
	
	# we must wait for scene loading to finish so MissionHUD._ready connects to
	# the setup_mission signal
	call_deferred("setup_mission")

func restart_mission():
	start_mission(self.current_mission_number)

func is_last_mission(mission_number):
	return mission_number == MAX_MISSION_NUMBER

func start_next_mission():
	if !is_last_mission(self.current_mission_number):
		start_mission(self.current_mission_number + 1)
	else:
		print("ERROR: cannot start mission after %d, which is last" % self.current_mission_number)

func setup_mission():
	self.phase = Phase.Setup
	emit_signal("setup_mission")

func run_mission():
	assert(self.phase == Phase.Setup, "phase is " + str(self.phase))
	self.phase = Phase.Run
	emit_signal("run_mission")

func succeed_mission():
	# we should only finish mission while Running
	assert(self.phase == Phase.Run, "phase is " + str(self.phase))
	self.phase = Phase.Success
	emit_signal("succeed_mission")
	
func fail_mission():
	# we should only finish mission while Running
	assert(self.phase == Phase.Run, "phase is " + str(self.phase))
	self.phase = Phase.Failure
	emit_signal("fail_mission")
