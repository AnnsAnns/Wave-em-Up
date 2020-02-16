extends Tree

#Variable Declarations
onready var main_menu = "res://Scenes/Main Menu/Main_Menu.tscn"
var current_scene = "res://Scenes/Main Menu/Main_Menu.tscn"

## Option variables
var music_volume = 100
var sound_effects_volume = 100


# Call to Change Room
func scene_goto(scene):
	var result = get_tree().change_scene(scene)
	
	# Store Current Scene
	if (result == 0):
		current_scene = scene

#Toggle Fullscreen
func fullscreen():
	if (OS.is_window_fullscreen() == false):
		OS.set_window_fullscreen(true)
	elif (OS.is_window_fullscreen() == true):
		OS.set_window_fullscreen(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
