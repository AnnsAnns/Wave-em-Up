extends Position2D

func gun_functions():
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("left_mouse"):
		$SynthwaveParticle.emitting = true
	else:
		$SynthwaveParticle.emitting = false

func _process(delta):
	gun_functions()
