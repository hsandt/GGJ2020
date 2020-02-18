# This doesn't work, see
# https://github.com/godotengine/godot/issues/36314
# Workaround that still use Resources: export generic Resources
# (but a bit cumbersome to edit, so we chose solution below)
#extends Resource
#class_name MissionData

#export(Array, MissionInfo) var mission_info_array

# Instead, we make this a pure class to get and cache mission info.
# We instantiate it in GameManager._ready (owned) with .new()
# Other alternatives:
# a. extends Node and make this an autoload singleton,
#    call load_mission_info_array in _ready. Anyone can access
#    MissionData, including GameManager.
# b. extends Node and save a prefab Scene containing just a node
#    with this script attached. Let GameManager .instance()
#    this prefab, attach it to root and keep reference to it.
#    Less abstract, but allows us expose mission_count in
#    MissionData and tune it on the prefab
class_name MissionData

# exporting is useless for singletons and this is instantiated
# by GameManager, so let's hardcode this count at once
# (at least there is only one place to change the count when I add
# a new scene)
# if we don't set mission count manually, then we must count
# the number of mission scenes that exist by using something like
# https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder
const MISSION_COUNT = 5

var mission_info_array = []

func load_mission_info_array():
	for i in range(MISSION_COUNT):
		# convert from 0-based index to natural count
		var number = i + 1
		print("loading mission info %02d" % number)
		mission_info_array.append(load("res://Data/MissionInfo%02d.tres" % number))

func get_mission_info(number):
	# convert from natural count to 0-based index
	return mission_info_array[number - 1]
