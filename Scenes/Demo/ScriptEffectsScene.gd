extends Node2D

var cluster_particles_class = preload("res://Scenes/Effects/LinearFountainParticles.tscn")
var defined_material_class = preload("res://Scripts/Enums/PredefParticleMaterial.cs")

# Called when the node enters the scene tree for the first time.
func _ready():
	var demo_cluster1 = cluster_particles_class.instance()
	var demo_cluster2 = cluster_particles_class.instance()
	var demo_cluster3 = cluster_particles_class.instance()
	var demo_cluster4 = cluster_particles_class.instance()
	#var selected_material = defined_material_class.new()
	#var selected_material = defined_material_class.PREDEF_MATERIAL_DEFAULT_LIGHT_RAIN
	#selected_material = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_LIGHT_RAIN
	demo_cluster1._Ready()
	demo_cluster1.SetSourcePoints(4, true)
	#demo_cluster1.SetSourcePointsWithDistance(4, true, 250)
	demo_cluster1.SetActiveSetsMaterialName("LIGHT_RAIN")
	demo_cluster1.SetVisible("all", true)
	demo_cluster1.SetBasicAttributes(25, 1.8, 0.31, 0.122, 32.0, 55.0);
	demo_cluster1.position = Vector2(150, 180)
	#demo_cluster1.DebugParticleTexture("")
	demo_cluster1.Emit(true)
	add_child(demo_cluster1)
	demo_cluster2._Ready()
	demo_cluster2.SetSourcePoints(4, true)
	demo_cluster2.SetActiveSetsMaterialName("LIGHT_RAIN")
	demo_cluster2.SetVisible("all", true)
	demo_cluster2.SetBasicAttributes(29, 2.5, 0.31, 0.122, 32.0, 55.0);
	demo_cluster2.position = Vector2(380, 110)
	demo_cluster2.Emit(true)
	add_child(demo_cluster2)
	demo_cluster3._Ready()
	demo_cluster3.SetSourcePoints(4, true)
	demo_cluster3.SetActiveSetsMaterialName("HEAVY_RAIN")
	demo_cluster3.SetModulateColor("all", Color(0.52, 0.42, 0.71, 0.32))
	demo_cluster3.SetVisible("all", true)
	demo_cluster3.SetBasicAttributes(21, 2.9, 0.31, 0.122, 32.0, 55.0);
	demo_cluster3.position = Vector2(560, 310)
	demo_cluster3.Emit(true)
	add_child(demo_cluster3)
	demo_cluster4._Ready()
	demo_cluster4.SetSourcePoints(4, true)
	demo_cluster4.SetActiveSetsMaterialName("FEINT_SMOKE")
	demo_cluster4.SetModulateColor("all", Color(0.62, 0.61, 0.55, 0.245))
	demo_cluster4.SetVisible("all", true)
	demo_cluster4.SetBasicAttributes(45, 2.9, 0.375, 0.265, 32.0, 55.0);
	demo_cluster4.rotation_degrees = 180
	demo_cluster4.position = Vector2(720, 160)
	demo_cluster4.Emit(true)
	add_child(demo_cluster4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
