extends KinematicBody2D

export var speed = 1500
var velocity = Vector2()

func start(pos, rot):
	rotation = rot
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		$Particles2D.emitting = false
		yield(get_tree().create_timer(3), "timeout")
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
