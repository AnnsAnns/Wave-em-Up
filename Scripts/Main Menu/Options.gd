extends Control

onready var fullscreen_node = get_node("Menu/Title/Buttons/Fullscreen")

func _process(delta):
	
	
	
	# Button Stay True when Fullscreen
	if (OS.is_window_fullscreen() == true):
		fullscreen_node.set_pressed(true)

func _on_Back_button_up():
	$"/root/Singleton".scene_goto("res://Scenes/Main Menu/Main_Menu.tscn")

func _on_Fullscreen_button_up():
	$"/root/Singleton".fullscreen()
