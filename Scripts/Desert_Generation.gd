extends TileMap

var xSize = 40
var ySize = 30
var rng = RandomNumberGenerator.new()
var start = Vector2.ZERO

onready var enemy_spawner = load("res://Scenes/Entities/Enemy_Spawner.tscn")

export (int)var tilesX = 16
export (int)var tilesY = 9

var dynImg = Image.new()
export var tilesLimit = 6
var endTilePlaced = false

var START_COLOR = Color.green
var PATH_COLOR = Color.blue
var END_COLOR = Color.red

var currentTilePos = Vector2.ZERO
var tilesPlaced = 0

func _ready():
	call_deferred("generate")

func generate():
	dynImg = Image.new()
	tilesPlaced = 0
	endTilePlaced = false
	rng.randomize()
	start.x = (xSize -1) / 2
	start.y = (ySize-1) / 2
	var tilesXSize = tilesX * (cell_size.x * scale.x)
	var tilesYSize = tilesY * (cell_size.y * scale.y)
	position = Vector2((-start.x * tilesXSize) - tilesXSize/2, (-start.y * tilesYSize) - tilesYSize/2)
	
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

func draw_tile_map():
	clear()
	
	dynImg.lock()
	
	for y in range(ySize - 1):
		for x in range(xSize - 1):
			var pv = Vector2(x,y)
			var pc = dynImg.get_pixelv(pv)
			pv = Vector2(x * tilesX,y * tilesY)
			if pc == Color.black:
				for ntx in range(tilesX):
					for nty in range(tilesY):
						var newtilep = Vector2(pv.x + ntx,pv.y + nty)
						set_cellv(newtilep, 0)
			else:

				var ntm = randi() % 4 + 2
				set_cellv(pv, ntm)
				
				if pc == END_COLOR:
					var newP = Vector2((x - start.x) * 512,(y - start.y) * 288)
					newP = newP * 2
					get_parent().get_parent().end_position = newP
				
				if pc == PATH_COLOR:
					var es = enemy_spawner.instance()
					get_parent().get_parent().call_deferred("add_child",es)
					es.add_to_group("Spawner")

					var newP = Vector2((x - start.x) * 512,(y - start.y) * 288)
					newP = newP * 2
					newP.x -= 512
					newP.y -= 288
					var randOffset = Vector2(randi() % 1024,randi() % 432)
					randOffset.x = clamp(randOffset.x, 64, 960)
					randOffset.y = clamp(randOffset.y, 64, 368)
					match ntm:
						2:
							es.global_position = newP + randOffset
						3:
							randOffset.x = clamp(randOffset.x, 64, 960)
							randOffset.y = clamp(randOffset.y, 64, 158)
							es.global_position = newP + randOffset
						4:
							randOffset.x = clamp(randOffset.x, 64, 384)
							randOffset.y = clamp(randOffset.y, 64, 170)
							es.global_position = newP + randOffset
						5:
							randOffset.x = clamp(randOffset.x, 64, 640)
							randOffset.y = clamp(randOffset.y, 64, 152)
							es.global_position = newP + randOffset
						6:
							randOffset.x = clamp(randOffset.x, 512, 512)
							randOffset.y = clamp(randOffset.y, 288, 288)
							es.global_position = newP + randOffset
	
	update_bitmask_region()
	
	var endid = 7
	
	set_cellv(Vector2(start.x * tilesX,start.y * tilesY), 1)
	
	if dynImg.get_pixelv(currentTilePos + Vector2.UP).b > 0.5:
		endid = 8
		
	elif dynImg.get_pixelv(currentTilePos + Vector2.DOWN).b > 0.5:
		endid = 7
		
	elif dynImg.get_pixelv(currentTilePos + Vector2.LEFT).b > 0.5:
		endid = 10
		
	elif dynImg.get_pixelv(currentTilePos + Vector2.RIGHT).b > 0.5:
		endid = 9
	
	set_cellv(Vector2(currentTilePos.x * tilesX,currentTilePos.y * tilesY), endid)
	
	dynImg.unlock()
	
	update_dirty_quadrants()
