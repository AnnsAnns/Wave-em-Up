extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Singleton".scene_goto("res://Scenes/Level/Level_Desert.tscn")
