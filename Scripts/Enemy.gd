extends KinematicBody2D

enum AI_STATE {IDLE, CHASE, ATTACK}
var state = AI_STATE.IDLE

var path : = PoolVector2Array()
var speed = 100
export (int) var maxHealth = 100
var health = maxHealth

export (float) var tileSize = 1
onready var player = $"../Player/KinematicBody2D"
onready var nav = $"../Navigation"

var t = 0.1
var hit = false
var distance_to_walk


func _ready():
	health = maxHealth
	$Label.text = "HP: " + String(health)
	t = 0.1
	
	state = AI_STATE.CHASE

func _process(delta):
	t -= delta
	
	if hit == true:	lose_health()

func _physics_process(delta):
	path = nav.get_simple_path(position, player.global_position)
	distance_to_walk = speed * delta
	
	match state:
		AI_STATE.IDLE:	pass
		AI_STATE.CHASE:	chase()
		AI_STATE.ATTACK:	pass

func chase():
	if path.size() > 0:
		for i in range(path.size()):
			if position.distance_to(path[i]) > distance_to_walk:
				look_at(path[i])
				var dir = (path[i]) - position
				dir = dir.normalized()
# warning-ignore:return_value_discarded
				move_and_slide(dir * speed)

func lose_health():
	if t > 0:	return
	if hit == false:	return
	
	health = clamp(health - 1, 0, maxHealth)
	$Label.text = "HP: " + String(health)
	t = 0.1
	hit = false
	if health <= 0:
		queue_free()
