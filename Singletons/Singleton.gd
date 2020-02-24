extends Tree

#Variable Declarations
onready var main_menu = "res://Scenes/Main Menu/Main_Menu.tscn"
onready var desert_level = "res://Scenes/Level/Level_Desert.tscn"
#onready var boss_level = "res://Scenes/Level/Level_Desert"
var current_scene = null

## Option variables
var music_volume = 100
var sound_effects_volume = 100

var loading_screen

var load_timer = Timer.new()
var sc

func _ready():
	if current_scene == null && loading_screen == null:
		var lc = load("res://Scenes/Other Menus/Loading_Screen.tscn")
		loading_screen = lc.instance()
		loading_screen.set_name("Death Menu")
		get_tree().get_root().call_deferred("add_child",loading_screen)
		
		add_child(load_timer)
		load_timer.connect("timeout",self,"scene_gotostart") 
		load_timer.one_shot = true
		load_timer.stop()
		load_timer.wait_time=1


# Call to Change Room
func scene_goto(scene):
	sc = scene
	loading_screen.get_child(0).start_loading()
	load_timer.start()

func scene_gotostart():
	get_tree().get_root().remove_child(loading_screen)
	var result
	if typeof(sc) == TYPE_STRING:
		result = get_tree().change_scene(sc)
	else:
		result = get_tree().reload_current_scene()
	
	if result == 0:
		current_scene = sc
		get_tree().get_root().call_deferred("add_child",loading_screen)
		print("DONE")

func scene_reload():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

#Toggle Fullscreen
func fullscreen():
	if (OS.is_window_fullscreen() == false):
		OS.set_window_fullscreen(true)
	elif (OS.is_window_fullscreen() == true):
		OS.set_window_fullscreen(false)
