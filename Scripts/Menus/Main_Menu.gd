extends Control

var x = false

func _process(delta):
	if Input.is_action_pressed("pickup"):
		$Loading.visible = true
		$Music.stop()
		yield(get_tree().create_timer(2), "timeout") # Fix it not showing up
		
		$"/root/Singleton".scene_goto("res://Scenes/Level/Level_Desert.tscn")


func _on_Flash_timeout():
	if not x:
		$LogoStart.hide()
		x = true
	else:
		$LogoStart.show()
		x = false
