extends Node

enum Phase {
	Setup,
	Run,
	Success,
	Failure
}

const MAX_MISSION_NUMBER = 3

signal setup_mission
signal run_mission
signal succeed_mission
signal fail_mission

# State
var current_mission_number : int
var phase : int  # Phase
# Mission success/failure is only confirmed when this count reaches 0
# (i.e. there is nothing running on screen anymore, and no event in preparation either)
var active_elements_count = 0
# How many bosses are still alive? Should be 0 to succeed.
var living_bosses_count = 0
# How many princesses are dead? Should be 0 to succeed.
var dead_princesses_count = 0

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
	self.active_elements_count = 0  # important to have correct count on run start
	self.living_bosses_count = 0
	self.dead_princesses_count = 0
	emit_signal("setup_mission")

func run_mission():
	assert(self.phase == Phase.Setup, "phase is " + str(self.phase))
	self.phase = Phase.Run
	emit_signal("run_mission")
	
	if self.active_elements_count == 0:
		print("ERROR: 0 active elements found on run start, mission will end immediately wth Failure, else it may never end.")
		fail_mission()

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

func decrement_active_elements_count():
	if phase != Phase.Run:
		print("ERROR: decrement_active_elements_count should only be called during Run phase, phase is %d" % phase)
		return
	
	active_elements_count -= 1
	call_deferred("check_active_elements_count")
	
func check_active_elements_count():
	if active_elements_count == 0:
		# no more elements active / tasks waiting, end mission and check
		# success/failure conditions now
		if living_bosses_count == 0 and dead_princesses_count == 0:
			print("success!")
			succeed_mission()
		else:
			if living_bosses_count > 0:
				print("%d bosses still live!" % living_bosses_count)
			if dead_princesses_count > 0:
				print("%d princess are dead!" % dead_princesses_count)
			print("failure!")
			fail_mission()
