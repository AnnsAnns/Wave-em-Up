extends Node2D

signal waterdrop_hit(body)
var waterdrop

func _ready():
	$Cloudsfadingin.play("Clouds coming in")
	start_raining()

func _on_WaterDrop_body_entered(body):
	emit_signal("waterdrop_hit", body)

func start_raining():
	for l in range(9):
		for x in range(25):
			waterdrop = $WaterDrop.duplicate()
			waterdrop.position = Vector2(76 * x, 0)
			$waterdrop.AnimatedPlayer.play("watedrop_fall")
			
			yield(get_tree().create_timer(rand_range(0, 2)), "timeout")
