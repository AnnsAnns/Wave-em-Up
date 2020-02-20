extends KinematicBody2D

var path : = PoolVector2Array()
var speed = 100

onready var player = $"../Player/KinematicBody2D"
onready var nav = $"../Navigation"
onready var line = $"../Line2D"

func _physics_process(delta):
	path = nav.get_simple_path(position, player.position)
	line.points = path
	
	var distance_to_walk = speed * delta
	
	if path.size() > 0:
		for i in range(path.size()):
			if position.distance_to(path[i]) > distance_to_walk:
				look_at(path[i])
				var dir = path[i] - position
				dir = dir.normalized()
				move_and_slide(dir * speed)
