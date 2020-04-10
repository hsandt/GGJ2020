# Normally I would embed the MissionInfo array data in this class
# and export it to edit it directly with:
# export(Array, MissionInfo) var mission_info_array
# but due to https://github.com/godotengine/godot/issues/36314
# I will just put the mission count here, and load MissionInfo
# on start
extends Resource
class_name MissionData

# Mission count. Make sure to update this in the Singleton scene
# after adding new scenes.
# If we don't set mission count manually, then we must count
# the number of mission scenes that exist by using something like
# https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder
export(int) var mission_count = 1

var mission_info_array = []

func load_mission_info_array():
	for i in range(self.mission_count):
		# convert from 0-based index to natural count
		var number = i + 1
		print("[MissionData] Loading MissionInfo%02d..." % number)
		mission_info_array.append(load("res://Data/MissionInfo%02d.tres" % number))

func get_mission_info(number):
	# convert from natural count to 0-based index
	return mission_info_array[number - 1]
