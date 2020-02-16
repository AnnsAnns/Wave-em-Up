extends Node2D

var PlayerPickedUpGun = false

func _ready():
	$Player/KinematicBody2D/Gun.hide()

func _on_Area2D_body_entered(body):
	print("b")
	if body == $Player/KinematicBody2D and not PlayerPickedUpGun:
		print("Pog")
		$PickupGun.hide()
		$Player/KinematicBody2D/Gun.show()
		PlayerPickedUpGun = true
