extends AudioStreamPlayer

var firing = false

func _on_Gun_IsFiring():
	if firing:
		return
		
	firing = true
	while not volume_db == -15:
		if not firing:
			return
		
		volume_db += 1
		yield(get_tree().create_timer(0.25), "timeout") # Await 0.05secs to make it smooth
		
func _on_Gun_IsNotFiring():
	firing = false
	
	while not volume_db == -25:
		if firing:
			return
		
		volume_db -= 1
		yield(get_tree().create_timer(1), "timeout")
