extends KinematicBody2D

signal IsFiring
signal IsNotFiring

func gun_functions():
	if Input.is_action_pressed("left_mouse"):
		$SynthwaveParticle.emitting = true
		emit_signal("IsFiring")
	else:
		$SynthwaveParticle.emitting = false
		emit_signal("IsNotFiring")

func _process(delta):
	gun_functions()
