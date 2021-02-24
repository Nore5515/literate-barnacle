extends Node


var savedStack
var movingStack
var stacks = []


var canvasLayer
export (NodePath) var canvasLayerPath


func _ready():
	canvasLayer = get_node(canvasLayerPath)


func canSavedStackMoveToSelected() -> bool:
	var rangeCheck = false
	var terrainCheck = false
	
	var loc = get_parent().getHighlightedTileLoc()
	var slowestMove = savedStack.slowestMove
	
	var distanceTo = getStackDistanceTo(savedStack, loc)
	if distanceTo <= slowestMove:
		rangeCheck = true
	
	var tile = get_parent().get_node("Grid").get_cellv(loc)
	if tile >= 0:
		if savedStack.canStackFly():
			terrainCheck = true
		else:
			if tile != 1:
				terrainCheck = true

	if rangeCheck && terrainCheck:
		#print ("YES")
		return true
	#print ("NO")
	return false



func getStackDistanceTo(stack, loc) -> float:
	return loc.distance_to(stack.location)



# Check the highlighted tile for any stacks
# Return the first stack found
func getSelectedStack():
	var highlightLoc = get_parent().get_node("Grid").getLocAtPos(get_parent().get_node("Highlight").global_position)
	for stack in stacks:
		if stack.location == highlightLoc:
			return stack
	return null


func isSelectingTileWithStack():
	var highlightLoc = get_parent().get_node("Grid").getLocAtPos(get_parent().get_node("Highlight").global_position)
	for stack in stacks:
		if stack.location == highlightLoc:
			return true
	return false


# Begin moving unit.
func moveUnitPressed() -> void:
	#print ("Move Unit Pressed...")
	if savedStack == null:
		#print ("Saving Stack.")
		if isSelectingTileWithStack():
			savedStack = getSelectedStack()
			movingStack = true
			canvasLayer.get_node("MovingUnitLabel").visible = true
			canvasLayer.get_node("UnitPanel/UnitMoveButton").disabled = true
	else:
		#print ("Moving and Clearing Stack.")
		moveStackToSelected(savedStack)
		canvasLayer.get_node("UnitPanel/UnitMoveButton").disabled = true
		movingStack = false
		canvasLayer.get_node("MovingUnitLabel").visible = false
		savedStack = null
	canvasLayer.updateUnitDetails()

# Moves the given stack to the currently highlighted tile
# If there is a friendly stack on the tile, merge
func moveStackToSelected(stack) -> bool:
	print ("MOVE STACK TO SELECTED")
	# FIX THIS
	if stack.location != get_parent().getHighlightedTileLoc():
		print ("A")
		if stacks.has(stack):
			print ("B")
			if isSelectingTileWithStack():
				print ("C")
				stacks.erase(stack)
				getSelectedStack().absorbStack(stack)
			var loc = get_parent().getHighlightedTileLoc()
			stack.moveDistance(getStackDistanceTo(stack, loc))
			stack.location = loc
			stack.position = get_parent().get_node("Grid").map_to_world(loc)
			return true
		else:
			return false
		canvasLayer.updateUnitDetails()
	return false

# PRE: You are selecting a tile that does not have a stack on it.
# POST: There is now an empty stack on that tile.
func addEmptyStackToSelected(): # -> UnitStack.tscn
	var instance = load("res://Scenes/UnitStack.tscn").instance()
	var loc = get_parent().getHighlightedTileLoc()
	get_parent().get_node("Grid").add_child(instance)
	instance.position = get_parent().get_node("Grid").map_to_world(loc)
	instance.location = loc
	stacks.append(instance)
	return instance
