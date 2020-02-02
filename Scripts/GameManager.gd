extends Node

enum Phase {
	Setup,
	Run
}

const MAX_MISSION_NUMBER = 2

var current_mission_number : int
var phase : int  # Phase

func go_to_title():
	var _result = get_tree().change_scene("res://Scenes/Title.tscn")

func start_mission(mission_number):
	self.current_mission_number = mission_number
	self.phase = Phase.Setup
	var _result = get_tree().change_scene("res://Scenes/Mission%02d.tscn" % mission_number)

func restart_mission():
	start_mission(self.current_mission_number)

func start_next_mission():
	var next_mission_number = self.current_mission_number + 1
	if next_mission_number <= MAX_MISSION_NUMBER:
		start_mission(next_mission_number)
