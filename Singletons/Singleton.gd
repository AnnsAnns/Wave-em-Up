extends Tree

var timestamp_class = preload("res://Scripts/Timestamp.gd")
#Variable Declarations
onready var main_menu = "res://Scenes/Main Menu/Main_Menu.tscn"
onready var desert_level = "res://Scenes/Level/Level_Desert.tscn"
onready var endless_level = "res://Scenes/Level/Level_Endless.tscn"
onready var clear_level = "res://Scenes/Other Menus/Game_Clear.tscn"
#onready var boss_level = "res://Scenes/Level/Level_Desert"
var current_scene = null

#Remove signals should it be clear that their use may not be required
#signal data_loaded()
#signal data_saved()

## Option variables
var music_volume = 100
var sound_effects_volume = 100

var loading_screen

var load_time_started = timestamp_class.timestamp.new()
var load_scene_completion = timestamp_class.timestamp.new()
var load_timer = Timer.new()
var data_saved = false
var data_loaded = true
var sc

func _ready():
	load_time_started.reset_time()
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

func reset_debug_timers():
	load_time_started.reset_time()
	load_scene_completion.reset_time()

# Call to Change Room
func scene_goto(scene):
	sc = scene
	loading_screen.get_child(0).start_loading()
	load_timer.start()

func scene_gotostart():
	get_tree().get_root().remove_child(loading_screen)
	var result
	load_scene_completion.reset_time()
	var ticks_load_time = load_scene_completion.subtract_ticks(load_time_started)
	if typeof(sc) == TYPE_STRING:
		print("changing scene to %s, loading time=%d" % [sc, ticks_load_time])
		result = get_tree().change_scene(sc)
		load_time_started.reset_time()
	else:
		print("reloading current scene, loading time=%d" % [ticks_load_time])
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
	OS.set_window_fullscreen(!OS.set_window_fullscreen)

const FILE_NAME = "user://waveemup-data.json"

var data = {
	"high score": 0,
	"music": 0.8,
	"sfx": 0.8,
	"fullscreen": false
}

func loaded_data_ready():
	print("loaded_data_ready() called")
	if Singleton.data["fullscreen"] == true: 
		$Fullscreen.pressed = true
		OS.window_fullscreen = true
	else:
		$Fullscreen.pressed = false
		OS.window_fullscreen = false

func save_data():
	var file = File.new()
	file.open_encrypted_with_pass(FILE_NAME, File.WRITE, "qwerty")
	file.store_string(to_json(data))
	file.close()
	data_saved = true
	#emit_signal("data_saved")

func load_data():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		#file.open(FILE_NAME, File.READ)
		file.open_encrypted_with_pass(FILE_NAME, File.READ, "qwerty")
		var d = parse_json(file.get_as_text())
		file.close()
		if typeof(d) == TYPE_DICTIONARY:
			data = d
			data_loaded = true
			#emit_signal("data_loaded")
			print("load_data, emitting signal (data_loaded)")
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
