extends Node2D


# PRE: Ref has a move, hp, special and type field.
# ^ from Unit.gd
var unitRef = {
	"Flier": {
		"type": "Flier",
		"hp": 3,
		"move": 8,
		"cost": 15,
		"special": ["flying"]
	},
	"Inf": {
		"type": "Inf",
		"hp": 1,
		"move": 2,
		"cost": 4,
		"special": []
	}
}

### SCENE PROPERTIES ###
# Econ
var income = 10
var expenses = 0
var treasury = 110

# Structures
var allStructures = []
var cityCount = 0
var farmCount = 0

# Other
var mousingOverControl = false
var mousingOverUnitPanel = false
var mousingOverUI = false



### GETTERS/SETTERS
func getCityCount() -> int:
	return cityCount
func setCityCount(_cityCount) -> void:
	cityCount = _cityCount



# Check the highlighted tile for any cities
# Return the first city found
func getSelectedCityPos():
	var highlightLoc = $Grid.getLocAtPos($Highlight.global_position)
	if $Grid.isCityLoc(highlightLoc):
		return $Highlight.global_position
	return null

# Get the location of the highlighted tile
func getHighlightedTileLoc():
	var highlightLoc = $Grid.getLocAtPos($Highlight.global_position)
	return highlightLoc





func _ready():
	$StackManager.isSelectingTileWithStack()
	var u = load("res://Scripts/Unit.gd").new()
	u.type = "Inf"
	u.randomizeID()
	$Grid.genTerrainInSquare(Vector2(30,30))



### OTHER




# PRE: None.
# POST: Adds a key to "allStructures" called "City " + cityCount.
func addCityToStructures(cityLoc) -> void:
	allStructures.append({
		"City " + String (cityCount): cityLoc
	})
	cityCount += 1
	updateEcon()
	$CanvasLayer.updateEconDetails()

func addFarmToStructures(farmLoc) -> void:
	allStructures.append({
		"Farm " + String (farmCount): farmLoc
	})
	farmCount += 1
	updateEcon()
	$CanvasLayer.updateEconDetails()


func updateEcon() -> void:
	income = 10 + farmCount * 2


# PRE: You're giving it a selected tile's ID
# POST: It updates the CanvasLayer's tile details
func updateDetails(givenTile):
	if givenTile == 0:
		$CanvasLayer.updateDetails("Plains", "Flat, ordinary. Nothing exciting.")
	elif givenTile == 1:
		$CanvasLayer.updateDetails("Water", "Impassable by non-fliers. Wet.")
	elif givenTile == 2:
		$CanvasLayer.updateDetails("Woods", "Slowing to non-fliers. Woody.")
	else:
		$CanvasLayer.updateDetails("Invalid", "This is not a tile.")






func _input(event):
	if event.is_action_pressed("click"):
		if mousingOverUI == false:
			var response = $Grid.getTileAtPos(get_global_mouse_position())
			updateDetails(response)
			$Grid.placeHighlightAtPos(get_global_mouse_position())
			
			if $StackManager.isSelectingTileWithStack():
				$CanvasLayer.updateUnitDetails()
			
			if !$StackManager.movingStack:
				$CanvasLayer.updateUnitDetails()
				
				if $StackManager.isSelectingTileWithStack():
					$CanvasLayer/UnitPanel/UnitMoveButton.disabled = false
				else:
					$CanvasLayer/UnitPanel/UnitMoveButton.disabled = true
					
				
			else:
				$CanvasLayer/UnitPanel/UnitMoveButton.disabled = !$StackManager.canSavedStackMoveToSelected()

			if isSelectingCity():
				if response == 0:
					$CanvasLayer.unitButtonsAdjust("Plains")
				elif response == 2:
					$CanvasLayer.unitButtonsAdjust("Woods")
				else:
					assert("ERR; INVALID CITY TYPE SELECTED", true)
			else:
				$CanvasLayer.unitButtonsAdjust("")



	if event.is_action_pressed("esc"):
		$CanvasLayer/DetailPanel.visible = false
		$Highlight.visible = false
		$StackManager.movingStack = false
		$StackManager.savedStack = null
		$CanvasLayer/MovingUnitLabel.visible = false
		#$Grid.genTerrainInSquare(Vector2(30,30))


func endTurn():
	treasury += income
	treasury -= expenses
	updateAll()
	for stack in $StackManager.stacks:
		stack.endTurn()


func updateAll():
	$CanvasLayer.updateEconDetails()


func buildCityPressed():
	$Grid.buildCity()

func buildFarmPressed():
	$Grid.buildFarm()

func billTreasury(amount):
	if treasury >= amount:
		treasury -= amount
		$CanvasLayer.updateEconDetails()
		return true
	else:
		return false


func isSelectingCity():
	var highlightLoc = $Grid.getLocAtPos($Highlight.global_position)
	if $Grid.isCityLoc(highlightLoc):
		return true
	return false





# Add an inf unit to the selected stack
# If no stacks present create an empty stack and add 1 inf
func _on_BuyInfButton_pressed():
	if billTreasury(unitRef["Inf"].cost):
		if !$StackManager.isSelectingTileWithStack():
			$StackManager.addEmptyStackToSelected()
		if $StackManager.getSelectedStack() != null:
			$StackManager.getSelectedStack().addUnitByRef(unitRef["Inf"])
		$CanvasLayer.updateUnitDetails()

# Add a Flier unit to the selected stack
# If no stacks present create an empty stack and add 1 Flier
func _on_BuyFlierButton_pressed():
	if billTreasury(unitRef["Flier"].cost):
		if !$StackManager.isSelectingTileWithStack():
			$StackManager.addEmptyStackToSelected()
		if $StackManager.getSelectedStack() != null:
			$StackManager.getSelectedStack().addUnitByRef(unitRef["Flier"])
		$CanvasLayer.updateUnitDetails()


func _on_UnitPanel_mouse_entered():
	mousingOverChanges("UnitPanel", true)
func _on_UnitPanel_mouse_exited():
	mousingOverChanges("UnitPanel", false)

func _on_ControlPanel_mouse_entered():
	mousingOverChanges("ControlPanel", true)
func _on_ControlPanel_mouse_exited():
	mousingOverChanges("ControlPanel", false)

func mousingOverChanges(elementChange, isOver):
	if elementChange == "UnitPanel":
		mousingOverUnitPanel = isOver
	if elementChange == "ControlPanel":
		mousingOverControl = isOver
	if mousingOverUnitPanel || mousingOverControl:
		mousingOverUI = true
	else:
		mousingOverUI = false
