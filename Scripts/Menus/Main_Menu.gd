extends Control

func _on_Play_button_up():
	Singleton.scene_goto(Singleton.desert_level)

func _on_Quit_button_up():
	get_tree().quit()

func _on_Fullscreen_pressed():
	OS.window_fullscreen = $Fullscreen.pressed
