extends Node2D



var income = 10
var expenses = 0
var treasury = 0

var allStructures = []
var cityCount = 0

var mousingOverControl = false


func getCityCount():
	return cityCount


func addCityByLoc(cityLoc):
	allStructures.append({
		"City " + String (cityCount): cityLoc
	})
	cityCount += 1
	$CanvasLayer.updateEconDetails()


func _input(event):
	if event.is_action_pressed("click"):
		if mousingOverControl == false:
			var response = $Grid.getTileAtPos(get_global_mouse_position())
			if response == 0:
				$CanvasLayer.updateDetails("Plains", "Flat, ordinary. Nothing exciting.")
			elif response == 1:
				$CanvasLayer.updateDetails("Water", "Impassable by non-fliers. Wet.")
			elif response == 2:
				$CanvasLayer.updateDetails("Woods", "Slowing to non-fliers. Woody.")
			else:
				$CanvasLayer.updateDetails("Invalid", "This is not a tile.")
			$Grid.placeHighlightAtPos(get_global_mouse_position())
			
			if isSelectingCity():
				$CanvasLayer.unitButtonToggle(true)
			else:
				$CanvasLayer.unitButtonToggle(false)
				
			
	if event.is_action_pressed("esc"):
		$CanvasLayer/DetailPanel.visible = false
		$Highlight.visible = false
		$Grid.genTerrainInSquare(Vector2(10,10))



func endTurn():
	treasury += income
	treasury -= expenses
	updateAll()


func updateAll():
	$CanvasLayer.updateEconDetails()


func buildCityPressed():
	$Grid.buildCity()


func billTreasury(amount):
	if treasury >= amount:
		treasury -= amount
		return true
	else:
		return false


func isSelectingCity():
	var highlightLoc = $Grid.getLocAtPos($Highlight.global_position)
	if $Grid.isCityLoc(highlightLoc):
		return true
	return false


func _on_ControlPanel_mouse_entered():
	mousingOverControl = true
func _on_ControlPanel_mouse_exited():
	mousingOverControl = false


func _on_BuyInfButton_pressed():
	pass # Replace with function body.


func _on_BuyFlierButton_pressed():
	pass # Replace with function body.
