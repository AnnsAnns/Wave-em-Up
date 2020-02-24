extends Control

var x = false

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_pressed("pickup"):
		Singleton.scene_goto(Singleton.desert_level)
