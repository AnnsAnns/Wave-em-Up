extends StaticBody2D

var HP = 500

func lose_health():
	clamp(HP - 1, 0, HP)
	print(HP)
