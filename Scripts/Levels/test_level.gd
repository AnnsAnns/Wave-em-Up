extends Node2D

var PlayerPickedUpGun = false

func _ready():
	$Player/KinematicBody2D/Gun.hide()

func _on_Area2D_body_entered(body):
	if body == $Player/KinematicBody2D and not PlayerPickedUpGun:
		$PickupGun.hide()
		$Player/KinematicBody2D/Gun.show()
		PlayerPickedUpGun = true
