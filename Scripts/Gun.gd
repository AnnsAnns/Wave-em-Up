extends KinematicBody2D

signal IsFiring
signal IsNotFiring

export var speed = 200

var Bullet = preload("res://Scenes/Entities/Bullet.tscn")
var velocity = Vector2()

func gun_functions():
	if not $Cooldown.is_stopped():
		return
		
	if Input.is_action_pressed("left_mouse"):
		emit_signal("IsFiring")
		var b = Bullet.instance()
		b.start($Muzzle.global_position, get_rotation())
		get_tree().get_root().add_child(b)
		$Cooldown.start(0.5)
	else:
		emit_signal("IsNotFiring")

func _process(delta):
	gun_functions()
