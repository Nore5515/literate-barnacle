extends Node2D


var units = {}




func addUnit(newUnit):
	if units.keys().has(newUnit.ID):
		units[newUnit.ID] += 1
	else:
		units[newUnit.ID] = 1
	updateAmount()


func removeUnit(newUnit):
	if units.keys().has(newUnit.ID):
		if units[newUnit.ID] == 1:
			units.erase(newUnit.ID)
		else:
			units[newUnit.ID] -= 1
	else:
		assert(false, "ERR; REMOVED UNIT NOT IN STACK")
	updateAmount()


func updateAmount():
	var amount = 0
	#for unitType in units:
		#amount += unitType
	$Amount.text = String(amount)
