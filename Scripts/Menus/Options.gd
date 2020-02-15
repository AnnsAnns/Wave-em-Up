extends Control

onready var fullscreen_node = get_node("Menu/Title/Buttons/Fullscreen")

# Set Options Values
func _ready():
	
	# Button Stay True when Fullscreen
	if (OS.is_window_fullscreen() == true):
		fullscreen_node.set_pressed(true)
	
	# Set Sliders 
	get_node("Menu/Title/Buttons/Music/Music Slider").set_value($"/root/Singleton".music_volume)
	get_node("Menu/Title/Buttons/Music/Music Percentage").set_text(str($"/root/Singleton".music_volume) + "%")
	
	get_node("Menu/Title/Buttons/Sound Effects/Sound Effects Slider").set_value($"/root/Singleton".sound_effects_volume)
	get_node("Menu/Title/Buttons/Sound Effects/Sound Effects Percentage").set_text(str($"/root/Singleton".sound_effects_volume) + "%")


# Signals
func _on_Back_button_up():
	$"/root/Singleton".scene_goto("res://Scenes/Main Menu/Main_Menu.tscn")

func _on_Fullscreen_button_up():
	$"/root/Singleton".fullscreen()

func _on_Music_Slider_value_changed(value):
	$"/root/Singleton".music_volume = value
	$"Menu/Title/Buttons/Music/Music Percentage".set_text(str(value) + "%")

func _on_Sound_Effects_Slider_value_changed(value):
	$"/root/Singleton".sound_effects_volume = value
	$"Menu/Title/Buttons/Sound Effects/Sound Effects Percentage".set_text(str(value) + "%")
