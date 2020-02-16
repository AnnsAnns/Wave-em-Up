extends KinematicBody2D

func gun_functions():
	
	if Input.is_action_pressed("left_mouse"):
		$SynthwaveParticle.emitting = true
		$Music.stream_paused = false
	else:
		$SynthwaveParticle.emitting = false
		$Music.stream_paused = true

func _process(delta):
	gun_functions()
