extends KinematicBody2D

signal IsFiring
signal IsNotFiring

var lastRot = float()
var lastPos = Vector2()

onready var particles = find_node ("SynthwaveParticle", true, false)
onready var smooth = find_node ("SmoothRay", true, false)

func gun_functions():
	if Input.is_action_pressed("left_mouse"):
		particles.emitting = true
		emit_signal("IsFiring")
	else:
		particles.emitting = false
		emit_signal("IsNotFiring")

func _process(_delta):
	gun_functions()

func _physics_process(delta):
	if smooth == null:
		return
	
	var dif = lastRot-rotation
	smooth.look_at(lastPos)
	smooth.rotation = lerp_angle(smooth.rotation, 0, delta * 4)
	lastPos = smooth.global_position + (smooth.get_global_transform().x * 160 * (abs(dif) + 1))
	lastRot = rotation
