extends Node2D


var units = []
var location

var slowestMove = -1


# SET/GETS
func setLocation(newLoc) -> void:
	location = newLoc
func getLocation() -> Vector2:
	return location

func getUnitMove(unitID) -> int:
	for unit in units:
		if unit.ID == unitID:
			return unit.move
	return -1

func getDetails() -> String:
	updateStats()
	var txt = ""
	txt += "Stack of " + String(units.size())
	txt += "\nSlowest Move: " + String(stepify(slowestMove, 0.01))
	txt += "\n" + getFormattedUnits()
	return txt


# UNIT ARRAY INTERACTIONS
func addUnitByRef(newUnitRef) -> void:
	var unitInstance = load("res://Scripts/Unit.gd").new()
	unitInstance.genFromRef(newUnitRef)
	units.append(unitInstance)
	updateStats()

func removeUnit(newUnit) -> bool:
	for unit in units:
		if unit.ID == newUnit.ID:
			units.erase(unit)
			updateStats()
			return true
	updateStats()
	return false

func getFormattedUnits() -> String:
	var txt = ""
	for unit in units:
		txt += String(unit.type) + ","
	return txt

func canStackFly() -> bool:
	for unit in units:
		if !unit.special.has("flying"):
			return false
	return true


### OTHER ###
func updateStats():
	updateMove()
	updateCount()
	
	
func updateCount():
	$Amount.text = String(units.size())

func updateMove():
	for unit in units:
		if slowestMove == -1:
			slowestMove = unit.currentMove
		else:
			if unit.currentMove < slowestMove:
				slowestMove = unit.currentMove

func endTurn():
	#print ("END TURN")
	slowestMove = -1
	for unit in units:
		unit.currentHP = unit.maxHP
		unit.currentMove = unit.maxMove
		#print (unit.currentMove)
	updateStats()

func moveDistance(dist):
	#print ("Moving distance ", dist)
	for unit in units:
		if unit.currentMove >= dist:
			unit.currentMove -= dist
		else:
			assert ("ERR; MOVE FURTHER THAN CURRENT MOVE", true)
	updateStats()

func absorbStack(otherStack):
	for otherUnit in otherStack.units:
		units.append(otherUnit)
	otherStack.queue_free()
	updateStats()
