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
	txt += "STACK of " + String(units.size())
	txt += "\nSlowest Move: " + String(slowestMove)
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



### OTHER ###
func updateStats():
	updateMove()

func updateMove():
	for unit in units:
		if slowestMove == -1:
			slowestMove = unit.currentMove
		else:
			if unit.currentMove < slowestMove:
				slowestMove = unit.currentMove




