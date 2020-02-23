extends KinematicBody2D

var HP = 500
var random_idk_im_tired = 0

func lose_health():
	# Needs Fix
	HP = clamp(HP - 1, 0, HP)

func _on_WillowTimer_timeout():
	if random_idk_im_tired == 0:
		$Willowblade.animation = "Angry"
	elif random_idk_im_tired == 1:
		$Willowblade.animation = "Flex"
	elif random_idk_im_tired == 2:
		$Willowblade.animation = "default"
	elif random_idk_im_tired == 3:
		$Willowblade.animation = "looking_at_player"
	
	if random_idk_im_tired == 3:
		random_idk_im_tired = 0
	
	random_idk_im_tired += 1


func _on_AttackTimer_timeout():
	pass # This would regulate which attack he chooses
