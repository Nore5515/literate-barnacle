extends TileMap







func _ready():
	randomize()


func getTileAtPos(pos):
	var gridLoc = world_to_map(pos)
	
	return get_cellv(gridLoc)


func placeHighlightAtPos(pos):
	var highlight = get_parent().get_node("Highlight")
	if highlight.visible == false:
		highlight.visible = true
	var gridLoc = world_to_map(pos)
	highlight.global_position = map_to_world(gridLoc)
	

func genTerrainInSquare(size):
	var terrainArray = genTerrainArray(size)
	var tile
	
	#for line in terrainArray:
	#	print (line)
	#print ("\n\n")
	
	for y in range (terrainArray.size()):
		for x in range (terrainArray[y].size()):
			if terrainArray[y][x] == "Nada":
				tile = 0
			elif terrainArray[y][x] == "Water":
				tile = 1
			elif terrainArray[y][x] == "Forest":
				tile = 2
			else:
				#print ("ERR")
				assert(false, "The terrain array had an invalid tile type")
			set_cell(x,y, tile)


func genTerrainArray(size):
	var terrainArray = []
	
	genTerrainSourceArray(size, terrainArray)
	expandTerrainSources(terrainArray)

	return terrainArray


func genTerrainSourceArray(size, array):
	var terrainRow
	var roll
	
	var noWater = true
	var noWaterLuck = 0
	
	# Create Terrain Sources
	for y in range (size.y):
		terrainRow = []
		for x in range (size.x):
			roll = rand_range(0,100)
			if roll < 10:
				terrainRow.append("Forest")
			elif roll < 12 + noWaterLuck:
				terrainRow.append("Water")
				noWater = false
				noWaterLuck = 0
			else:
				terrainRow.append("Nada")
			
			if noWater:
				noWaterLuck += 1

		array.append(terrainRow)


func expandTerrainSources(array):
	var roll
	var expandPenalty = 0
	
	# For each source, expand it
	for y in range (array.size()):
		for x in range (array[0].size()):
			if array[y][x] != "Nada":
				if array[y][x] == "Forest":
					callSpreadUntilExhausted(Vector2(x,y), array, 20)
				elif array[y][x] == "Water":
					callSpreadUntilExhausted(Vector2(x,y), array, 10)
			else:
				expandPenalty = 0


func prettyPrintArray(array):
	for line in array:
		print (line)
	print ("\n")


func callSpreadUntilExhausted(location, array, exhaustionTick):
	var roll
	var expandPenalty = 0
	var expanding = true
	
	while expanding:
		roll = round(rand_range(0,100))
		if roll < 100 - expandPenalty:
			spreadTerrain(location, array)
			expandPenalty += exhaustionTick
		else:
			expanding = false


func spreadTerrain(tile, array):
	var rng = RandomNumberGenerator.new()
	# Left, Up, Right, Down
	var direction = round(rand_range(0,4))
	#print ("\t\tDIR: ", direction)
	
	# UP
	if direction == 0:
		#print ("rolled up")
		#print ("Is ", tile, "'s y bigger than 0?")
		if tile.y > 0:
			
			#print (array[tile.y-1][tile.x], " at ", tile.y-1, ",", tile.x, " becoming ", array[tile.y][tile.x])
			
			array[tile.y-1][tile.x] = array[tile.y][tile.x]
		#else:
			#print ("Nope")
	
	# DOWN
	if direction == 1:
		print ("rolled down")
		print ("Is ", tile, "'s y smaller than the max grid y, ", array.size()-1)
		if tile.y < array.size()-1:
			
			print (array[tile.y+1][tile.x], " at ", tile.y+1, ",", tile.x, " becoming ", array[tile.y][tile.x])
			
			array[tile.y+1][tile.x] = array[tile.y][tile.x]
		#else:
			#print ("Nope")

	# RIGHT
	if direction == 2:
		#print ("rolled right")
		if tile.x < array[0].size()-1:
			array[tile.y][tile.x+1] = array[tile.y][tile.x]

	# LEFT
	if direction == 3:
		#print ("rolled left")
		if tile.x > 0:
			array[tile.y][tile.x-1] = array[tile.y][tile.x]
