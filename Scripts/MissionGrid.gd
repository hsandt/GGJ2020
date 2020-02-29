extends GridContainer

export(PackedScene) var mission_button_prefab

# doesn't work, same issue as in MissionData itself
# we'll access MissionData via GameManager instead
#export(MissionData) var mission_data

func _ready():
	# remove all the Mission Button examples, only there for WYSIWYG
	# slight performance cost, so don't hesitate to remove them
	# manually from the Scene where you're ready to export game
	for child in get_children():
		child.queue_free()
	
	for mission_info in GameManager.mission_data.mission_info_array:
		var mission_button = mission_button_prefab.instance() as MissionButton
		mission_button.mission_number = mission_info.number
		mission_button.name = "MissionButton%02d" % mission_info.number
		mission_button.text = "Mission %02d" % mission_info.number
		print("[MissionGrid] Generated %s" % mission_button.name)
		add_child(mission_button)
