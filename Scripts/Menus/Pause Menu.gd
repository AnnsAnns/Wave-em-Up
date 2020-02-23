extends Control

func _process(_delta):
	
	if (Input.is_action_just_pressed("ui_pause") and visible == false):
		get_tree().paused = true
		visible = true
	elif (Input.is_action_just_pressed("ui_pause") and visible == true):
		get_tree().paused = false
		visible = false

#Signals
func _on_Resume_button_up():
	visible = false
	get_tree().paused = false

func _on_Options_button_up():
	pass # Replace with function body.

func _on_Quit_button_up():
	$"/root/Singleton".scene_goto($"/root/Singleton".main_menu)
	get_tree().paused = false
