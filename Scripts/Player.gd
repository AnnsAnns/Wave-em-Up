extends Node2D

export (int) var speed = 400

var velocity = Vector2()
var mouse_position
var player_position

func get_input():
	velocity = Vector2()
	$KinematicBody2D.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = $KinematicBody2D.move_and_slide(velocity)
	get_function_based_on_position()
	
func get_function_based_on_position():
	mouse_position = get_global_mouse_position()
	player_position = $KinematicBody2D.position
