extends Node2D

signal waterdrop_hit(body)
var waterdrop

func _ready():
	$Cloudsfadingin.play("Clouds coming in")
	yield($Cloudsfadingin, "animation_finished")
	$Raining.play("Raining")
	yield($Raining, "animation_finished")
	$Raining.play("Raining")
	yield($Raining, "animation_finished")
	$Raining.play("Raining")
	yield($Raining, "animation_finished")
	$Cloudsfadingin.play_backwards("Clouds coming in")

func _on_WaterDrop_body_entered(body):
	print("Test")
	emit_signal("waterdrop_hit", body)
