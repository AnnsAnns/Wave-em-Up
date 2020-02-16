extends Control



func _on_Play_button_up():
	$"/root/Singleton".scene_goto("res://Scenes/Level/Level_1.tscn")

func _on_Options_button_up():
	$"/root/Singleton".scene_goto("res://Scenes/Main Menu/Options.tscn")

func _on_Credits_button_up():
	pass # Replace with function body.

func _on_Quit_button_up():
	get_tree().quit()

