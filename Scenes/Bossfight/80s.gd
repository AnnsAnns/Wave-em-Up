extends Node2D

var dub
onready var player = $"../Player/KinematicBody2D"

func _on_Area2D_body_entered(body):
	if not body == player:
		return
	
	player.get_parent().emit_signal("lose_health")
