extends WorldEnvironment

func _ready():
	Singleton.load_data()
	
	if Singleton.data["fullscreen"] == true: 
		$Fullscreen.pressed = true
		OS.window_fullscreen = true
	else:	
		$Fullscreen.pressed = false
		OS.window_fullscreen = false
	
	$HighScore.text = "High Score: " + String(Singleton.data["high score"])
	
	$SFXSlider.value = Singleton.data["sfx"]
	$MusicSlider.value = Singleton.data["music"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),lerp(-24, 6, Singleton.data["music"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"),lerp(-24, 6, Singleton.data["sfx"]))

func _on_Play_button_up():
	Singleton.scene_goto(Singleton.desert_level)

func _on_Endless_button_up():
	Singleton.scene_goto(Singleton.endless_level)

func _on_Quit_button_up():
	get_tree().quit()

func _on_Fullscreen_pressed():
	OS.window_fullscreen = $Fullscreen.pressed
	Singleton.data["fullscreen"] = $Fullscreen.pressed
	Singleton.save_data()

func _on_SFXSlider_value_changed(value):
	Singleton.data["sfx"] = value
	Singleton.save_data()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"),lerp(-72, 6, value))

func _on_MusicSlider_value_changed(value):
	Singleton.data["music"] = value
	Singleton.save_data()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),lerp(-72, 6, value))
