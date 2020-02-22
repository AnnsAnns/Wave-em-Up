extends Node2D

var WeatherAttack = preload("res://Scenes/Bossfight/WeatherEvent.tscn")

func _ready():
	add_child_below_node($Willowblade, WeatherAttack)
