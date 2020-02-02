extends Node

# Parameters
var initial_size = Vector2(ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height"))

# State
var hidpi_active: bool

func _input(event):
	# let user toggle hi-dpi resolution freely
	# (hi-dpi is hard to detect and resize is hard to force on start)
	if event.is_action_pressed("toggle_hidpi"):
		toggle_hidpi()
		
	if event.is_action_pressed("app_exit"):
		get_tree().quit()

func toggle_hidpi():
	if hidpi_active:
		# back to normal size
		OS.set_window_size(initial_size)
	else:
		# set hi-dpi size (nothing more than 2x window size)
		OS.set_window_size(initial_size * 2)
		
	# toggle
	hidpi_active = not hidpi_active
