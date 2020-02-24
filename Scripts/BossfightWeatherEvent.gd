extends Node2D

signal waterdrop_hit(body)
var waterdrop

onready var player = $"../Player/KinematicBody2D"

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
	
	if not body == player:
		return
	
	player.get_parent().emit_signal("lose_health")
