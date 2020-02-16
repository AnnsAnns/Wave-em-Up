extends TileMap

#Direction{UP=0 ,DOWN=1 ,LEFT=2 ,RIGHT=3}

var xSize = 40
var ySize = 30
var rng = RandomNumberGenerator.new()
var start = Vector2.ZERO

var dynImg = Image.new()
export var tilesLimit = 6
var endTilePlaced = false

var START_COLOR = Color.green
var PATH_COLOR = Color.blue
var END_COLOR = Color.red

var currentTilePos = Vector2.ZERO
var tilesPlaced = 0

#onready var tileMap = $TileRoot
# Called when the node enters the scene tree for the first time.
func _ready():
	generate()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		generate()

func generate():
	dynImg = Image.new()
	tilesPlaced = 0
	endTilePlaced = false
	rng.randomize()
	start.x = (xSize -1) / 2
	start.y = (ySize-1) / 2
	position = Vector2((-start.x * 512) - 256, (-start.y * 512)- 256)
	
	dynImg.create(xSize, ySize, false, Image.FORMAT_RGBA8)
	dynImg.fill(Color.black)
	
	dynImg.lock()
	dynImg.set_pixelv(start, START_COLOR)
	dynImg.unlock()
	
	print(start)
	
	var ntdir = 0
	currentTilePos = start
	
	while endTilePlaced == false:
		ntdir = rng.randi_range(0,3)
		place_tile(currentTilePos,ntdir, tilesPlaced >= tilesLimit)
	
	draw_tile_map()

func draw_tile_map():
	clear()
	
	dynImg.lock()
	
	for y in range(ySize - 1):
		for x in range(xSize - 1):
			var pv = Vector2(x,y)
			var pc = dynImg.get_pixelv(pv)
			if pc.b > 0.5:
				set_cellv(pv, 0)
	
	print(dynImg.get_pixelv(currentTilePos))
	
	var endid = 3
	var startid = 6
	set_cellv(currentTilePos, 0)
	set_cellv(start, 0)
	
	update_bitmask_region()
	
	if dynImg.get_pixelv(currentTilePos + Vector2.UP).b > 0.5:
		endid = 3
		
	elif dynImg.get_pixelv(currentTilePos + Vector2.DOWN).b > 0.5:
		endid = 1
		
	elif dynImg.get_pixelv(currentTilePos + Vector2.LEFT).b > 0.5:
		endid = 4
		
	elif dynImg.get_pixelv(currentTilePos + Vector2.RIGHT).b > 0.5:
		endid = 2
	
	
	if dynImg.get_pixelv(start + Vector2.UP).b > 0.5:
		startid = 6
		
	elif dynImg.get_pixelv(start + Vector2.DOWN).b > 0.5:
		startid = 5
		
	elif dynImg.get_pixelv(start + Vector2.LEFT).b > 0.5:
		startid = 8
		
	elif dynImg.get_pixelv(start + Vector2.RIGHT).b > 0.5:
		startid = 7
	
	set_cellv(currentTilePos, endid)
	set_cellv(start, startid)
	
	dynImg.unlock()

func place_tile(p:Vector2, d:int, end:bool):
	var np = p + Vector2.UP
	
	match d:
	#1 = DOWN
		1:
			np = p + Vector2.DOWN
	#2 = LEFT
		2:
			np = p + Vector2.LEFT
	#3 = RIGHT
		3:
			np = p + Vector2.RIGHT
	
	
	dynImg.lock()
	var pc = dynImg.get_pixelv(np)
	if (pc.r > 0 || pc.g > 0 || pc.b > 0):
		return
	
	dynImg.unlock()
	
	dynImg.lock()
	if (end == false):
		dynImg.set_pixelv(np, PATH_COLOR)
	else:
		dynImg.set_pixelv(np, END_COLOR)
		endTilePlaced = true
	dynImg.unlock()
	
	tilesPlaced += 1
	
	currentTilePos = np

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
