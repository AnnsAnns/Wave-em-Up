extends Tree

#Variable Declarations
var music_volume = 100
var sound_effects_volume = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Call to Change Room
func scene_goto(scene):
	var result = get_tree().change_scene(scene)
	print("Scene Change: " + str(result))

#Toggle Fullscreen
func fullscreen():
	if (OS.is_window_fullscreen() == false):
		OS.set_window_fullscreen(true)
	elif (OS.is_window_fullscreen() == true):
		OS.set_window_fullscreen(false)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
