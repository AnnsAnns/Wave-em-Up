extends Node2D

signal IsFiring
signal IsNotFiring

var lastRot = float()
var lastPos = Vector2()

onready var particles = find_node ("SynthwaveParticle", true, false)
onready var smooth = find_node ("SmoothRay", true, false)
onready var direct = find_node ("DirectRay", true, false)

var dead = false

func gun_functions():
	if dead == true:	return
	
	if Input.is_action_pressed("left_mouse"):
		particles.emitting = true
		emit_signal("IsFiring")
		if smooth == null:
			return
		smooth.enabled = true
		direct.enabled = true
	else:
		particles.emitting = false
		emit_signal("IsNotFiring")
		if smooth == null:
			return
		smooth.enabled = false
		direct.enabled = false

func hit_detection():
	if dead == true:	return
	
	if smooth.enabled == false: return
	
	var smoothCol = smooth.get_collider()
	var directCol = direct.get_collider()
	
	if  smoothCol != null && smoothCol.has_method("lose_health") == false:	smoothCol = null
	if  directCol != null && directCol.has_method("lose_health") == false:	directCol = null
	
	if smoothCol != null || directCol != null:
		if smoothCol == directCol:
			if smoothCol.has_method ("lose_health"):	smoothCol.hit = true
		else:
			if smoothCol != null && smoothCol.has_method ("lose_health"):	smoothCol.hit = true
			if directCol != null && directCol.has_method("lose_health"):	directCol.hit = true

func _process(_delta):
	if dead == true:	return
	gun_functions()

func _physics_process(delta):
	if dead == true:	return
	
	if smooth == null:
		return
	
	if Input.is_action_just_pressed("left_mouse"):
		lastPos = direct.global_position + direct.get_global_transform().x
	
	var dif = lastRot-rotation
	smooth.look_at(lastPos)
	smooth.rotation = lerp_angle(smooth.rotation, 0, delta * 4)
	lastPos = smooth.global_position + (smooth.get_global_transform().x * 160 * (abs(dif) + 1))
	lastRot = rotation
	
	hit_detection()
