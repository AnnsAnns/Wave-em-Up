extends KinematicBody2D

signal IsFiring
signal IsNotFiring

var lastRot = float()
var lastPos = Vector2()

func gun_functions():
	if Input.is_action_pressed("left_mouse"):
		$SynthwaveParticle.emitting = true
		emit_signal("IsFiring")
	else:
		$SynthwaveParticle.emitting = false
		emit_signal("IsNotFiring")

func _process(delta):
	gun_functions()

func _physics_process(delta):
	if $"SmoothRay" == null:	return
	
	var dif = lastRot-rotation
	$SmoothRay.look_at(lastPos)
	$SmoothRay.rotation = lerp_angle($SmoothRay.rotation, 0, delta * 4)
	lastPos = $SmoothRay.global_position + ($SmoothRay.get_global_transform().x * 60 * (abs(dif) + 1))
	lastRot = rotation
