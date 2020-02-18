extends GridContainer

export(PackedScene) var mission_button_prefab

# doesn't work, same issue as in MissionData itself
# we'll access MissionData via GameManager instead
#export(MissionData) var mission_data

func _ready():
	for mission_info in GameManager.mission_data.mission_info_array:
		var mission_button = mission_button_prefab.instance() as MissionButton
		mission_button.mission_number = mission_info.number
		mission_button.text = "Mission %02d" % mission_info.number
		add_child(mission_button)
