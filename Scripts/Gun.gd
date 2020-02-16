extends KinematicBody2D

func gun_functions():
	
	if Input.is_action_pressed("left_mouse"):
		$SynthwaveParticle.emitting = true
	else:
		$SynthwaveParticle.emitting = false

func _process(delta):
	gun_functions()
