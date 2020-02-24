extends Node2D

export (int) var speed = 400
export (int) var maxHealth = 6
var health = maxHealth

var velocity = Vector2()
var mouse_position
var player_position
onready var sprite = $KinematicBody2D/Player_Sprite
onready var arm_pivot = $KinematicBody2D/AimPivot
onready var arms = $KinematicBody2D/AimPivot/Arms
onready var muzzle = $KinematicBody2D/AimPivot/Muzzle

# warning-ignore:unused_signal
signal gain_health
# warning-ignore:unused_signal
signal lose_health

var dead = false

func _ready():
	health = maxHealth
	$KinematicBody2D/Label.text = "HP: " + String(health) + "/" + String(maxHealth)
	dead = false

func get_input():
	if dead == true:	return
	velocity = Vector2()
	arm_pivot.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func animate_body():
	if dead == true:	return
	#Flip sprite
	var p = mouse_position.x - player_position.x
	if p > 0:
		sprite.flip_h = false
		arms.position.y = 8
		arms.flip_v = false
		arm_pivot.position.y = 4
		muzzle.position.y = -3
	else:
		sprite.flip_h = true
		arms.position.y = -8
		arms.flip_v = true
		arm_pivot.position.y = -4
		muzzle.position.y = 3
	
	#Animate sprite
	match sprite.flip_h:
		false:
			if velocity.x < 0:	sprite.play("Backward", false)
			elif velocity == Vector2.ZERO:	sprite.play("Idle", false)
			else:	sprite.play("Forward", false)
		
		true:
			if velocity.x > 0:	sprite.play("Backward", false)
			elif velocity == Vector2.ZERO:	sprite.play("Idle", false)
			else:	sprite.play("Forward", false)

func _physics_process(_delta):
	if dead == true:	return
	get_input()
	velocity = $KinematicBody2D.move_and_slide(velocity)
	get_function_based_on_position()
	animate_body()

func get_function_based_on_position():
	if dead == true:	return
	mouse_position = get_global_mouse_position()
	player_position = $KinematicBody2D.global_position

func _on_AimPivot_IsNotFiring():
	if dead == true:	return
	arms.play("Normal",false)

func _on_AimPivot_IsFiring():
	if dead == true:	return
	arms.play("Shoot",false)

func _on_Player_gain_health():
	if dead == true:	return
	
	health = clamp(health + 1, 0, maxHealth)
	$KinematicBody2D/Label.text = "HP: " + String(health) + "/" + String(maxHealth)

func _on_Player_lose_health():
	if dead == true:	return
	health = clamp(health - 1, 0, maxHealth)
	$KinematicBody2D/Label.text = "HP: " + String(health) + "/" + String(maxHealth)
	
	if health <= 0:
		$KinematicBody2D/Player_Sprite/Shadow.visible = false
		sprite.play("Dead")
		dead = true
		arm_pivot.dead = true
		arm_pivot.emit_signal("IsNotFiring")
		arm_pivot.particles.emitting = false
		arms.play("Normal")
		if sprite.flip_h == false:
			arm_pivot.position = Vector2(26, 12)
			arm_pivot.rotation_degrees = -90
		else:
			arm_pivot.position = Vector2(26, -12)
			arm_pivot.rotation_degrees = 90
		
		var death_menu = load("res://Scenes/Other Menus/Death Menu.tscn")
		var dm_instance = death_menu.instance()
		dm_instance.set_name("Death Menu")
		add_child(dm_instance)
