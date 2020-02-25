extends KinematicBody2D

enum AI_STATE {IDLE, CHASE, ATTACK}
var state = AI_STATE.IDLE

var path : = PoolVector2Array()
export (float)var speed = 450
export (float)var atkSpeed = 1500
export (int) var maxHealth = 100
var health = maxHealth
export (float) var atkRange = 160
export (float) var atkDelay = 0.1
export (float) var canAtkDelay = 0.2

var player
var nav
onready var sprite = $Sprite
onready var detection = $Detection
onready var hitting = $Hit

onready var prepare = load("res://Assets/SFX/Enemy_Attack.wav")
onready var die = load("res://Assets/SFX/Enemy_Die.wav")
onready var hurt = load("res://Assets/SFX/Enemy_Hurt.wav")

onready var d1 = load("res://Assets/WillowbladeBoss/death.wav")
onready var d2 = load("res://Assets/WillowbladeBoss/evil_laugh1.wav")
onready var d3 = load("res://Assets/WillowbladeBoss/evil_laugh2.wav")
onready var d4 = load("res://Assets/WillowbladeBoss/evil_laugh3.wav")

var t = 0.1
var hit = false
var distance_to_walk = 0.0

var atk_timer = Timer.new()
var atk_dir = Vector2.ZERO

var can_atk_timer = Timer.new()

var aspd = atkSpeed

var can_atk = true
var in_range = false

var d = false

func _enter_tree():
	player = $"../Player/KinematicBody2D"
	nav = $"../Navigation"

func _ready():
	add_child(atk_timer)
	atk_timer.connect("timeout",self,"attack") 
	atk_timer.one_shot = true
	atk_timer.stop()
	atk_timer.wait_time=atkDelay

	add_child(can_atk_timer)
	can_atk_timer.connect("timeout",self,"can_attack") 
	can_atk_timer.one_shot = true
	can_atk_timer.stop()
	can_atk_timer.wait_time=canAtkDelay
	
	health = maxHealth
	t = 0.1
	
	state = AI_STATE.CHASE
	sprite.play("Idle")

func _process(delta):
	t -= delta
	
	if hit == true:	lose_health()

func _physics_process(delta):
	if player == null:
		player = $"../Player/KinematicBody2D"
		nav = $"../Navigation"
		return
	
	
	if d == true:
		hitting.get_child(0).disabled = true
		d = false
	
	path = nav.get_simple_path(position, player.global_position)
	distance_to_walk = speed * delta
	
	match state:
		AI_STATE.IDLE:
			sprite.play("Idle")
		
		AI_STATE.CHASE:
			in_range = detection.overlaps_body(player)
			sprite.play("Run")
			chase()
			if in_range == true && can_atk == true:
				prepare_attack()
		
		AI_STATE.ATTACK:
			aspd = lerp(aspd, 0, delta * 4.5)
			sprite.play("Attack")
# warning-ignore:return_value_discarded
			move_and_slide(atk_dir * aspd)
			if aspd <= 3.5:
				state = AI_STATE.CHASE
				can_atk_timer.start()
		-1:
			aspd = lerp(aspd, 0, delta * 3.5)
# warning-ignore:return_value_discarded
			move_and_slide(atk_dir * aspd)

func chase():
	var dir = (player.global_position - global_position).normalized()
	if path.size() > 0:
		for i in range(path.size()):
			if position.distance_to(path[i]) > distance_to_walk:
				dir = (path[i]) - position
				dir = dir.normalized()
	
# warning-ignore:return_value_discarded
	move_and_slide(dir * speed)
	if dir.x < 0:	sprite.flip_h = true
	elif dir.x > 0:	sprite.flip_h = false

func lose_health():
	if state == -1:	return
	if t > 0:	return
	if hit == false:	return
	
	health = clamp(health - 1, 0, maxHealth)
	t = 0.1
	hit = false
	if health <= 0:
		state = -1
		can_atk = false
		atk_timer.stop()
		can_atk_timer.stop()
		aspd = speed
		atk_dir = -(player.global_position - global_position).normalized()
		$Sprite/Shadow.visible = false
		$CollisionShape2D.disabled = true
		if get_parent().has_method("enemy_killed"):	get_parent().enemy_killed()
		$DeathParticles.emitting = true
		$Sound.stream = die
		
		var d = randi() % 4 + 1
		var f = randf() * 100
		if f < 80:
			sprite.play(String(d))
		else:
			sprite.play(String("Secret"))
			var rs = randi() % 4
			match rs:
				0:
					$Sound.stream = d1
				1:
					$Sound.stream = d2
				2:
					$Sound.stream = d3
				3:
					$Sound.stream = d4
		
		$Sound.play()
		return
	
	$Sound.stream = hurt
	$Sound.play()

func prepare_attack():
	if state == -1:	return
	state = AI_STATE.IDLE
	can_atk = false
	can_atk_timer.stop()
	atk_timer.start()
	atk_dir = (player.global_position - global_position).normalized()
	if atk_dir.x < 0:	sprite.flip_h = true
	elif atk_dir.x > 0:	sprite.flip_h = false
	aspd = atkSpeed
	$Sound.stream = prepare
	$Sound.play()

func attack():
	atk_timer.stop()
	can_atk_timer.stop()
	if state == -1:	return
	hitting.get_child(0).disabled = false
	state = AI_STATE.ATTACK

func can_attack():
	atk_timer.stop()
	can_atk_timer.stop()
	if state == -1:	return
	can_atk = true

func _on_Detection_body_entered(body):
	if state == -1:	return
	if body != player:	return
	
	if can_atk == true:
		can_atk = false
		prepare_attack()

func _on_Hit_body_entered(body):
	if state == -1:	return
	if body != player:	return
	
	player.get_parent().emit_signal("lose_health")
	d = true

func kill():
	health = -1
	hit = true
	t = -1
	lose_health()
