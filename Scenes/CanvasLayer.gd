extends CanvasLayer


var econPanelHidden = true
var unitPanelHidden = true
var controlPanelHidden = false



func updateDetails(title, desc):
	if $DetailPanel.visible == false:
		$DetailPanel.visible = true
	$DetailPanel/TileName.text = title + String(get_parent().getHighlightedTileLoc())
	$DetailPanel/TileDetails.text = desc



### ECON ###

func _on_EconButton_pressed():
	if econPanelHidden == true:
		revealEcon()
	else:
		hideEcon()


func revealEcon():
	updateEconDetails()
	econPanelHidden = false
	$EconPanel.rect_position.y = 0
	$EconPanel/EconButton.text = "^^^"


func hideEcon():
	econPanelHidden = true
	$EconPanel.rect_position.y = -122
	$EconPanel/EconButton.text = "vvv"


func updateEconDetails():
	var txt = ""
	txt += "INCOME: +" + String(get_parent().income)
	txt += "\nEXPENSES: -" + String(get_parent().expenses)
	txt += "\nNET: " + String(get_parent().income - get_parent().expenses)
	txt += "\n"
	txt += "\nTREASURY: " + String(get_parent().treasury)
	$EconPanel/EconDetails.text = txt



### CONTROL ###


func _on_ControlButton_pressed():
	if controlPanelHidden == true:
		revealControl()
	else:
		hideControl()


func revealControl():
	controlPanelHidden = false
	$ControlPanel.rect_position.y = 580
	$ControlPanel/ControlButton.text = "^^^"
		
func hideControl():
	controlPanelHidden = true
	$ControlPanel.rect_position.y = 507
	$ControlPanel/ControlButton.text = "vvv"


func unitButtonToggle(setting):
	if setting:
		$ControlPanel/BuyFlierButton.disabled = false
		$ControlPanel/BuyInfButton.disabled = false
	else:
		$ControlPanel/BuyFlierButton.disabled = true
		$ControlPanel/BuyInfButton.disabled = true

# GIVE CITY TYPE 
# IF CITY TYPE == "" THEN DISABLE ALL UNIT BUTTONS
# OTHERWISE SET BUTTONS BASED ON TYPE
######################################
# "Woods" - Inf and Fliers
# "Plains" - Inf
######################################
func unitButtonsAdjust(cityType: String) -> void:
	if cityType == "":
		$ControlPanel/BuyFlierButton.disabled = true
		$ControlPanel/BuyInfButton.disabled = true
	elif cityType == "Woods":
		$ControlPanel/BuyFlierButton.disabled = false
		$ControlPanel/BuyInfButton.disabled = false
	elif cityType == "Plains":
		$ControlPanel/BuyFlierButton.disabled = true
		$ControlPanel/BuyInfButton.disabled = false


func _on_EndTurnButton_pressed():
	get_parent().endTurn()


func _on_BuildCityButton_pressed():
	get_parent().buildCityPressed()


func _on_UnitButton_pressed():
	if unitPanelHidden == true:
		revealUnitPanel()
	else:
		hideUnitPanel()


func updateUnitDetails():
	$UnitPanel/UnitDetails.text = String(get_parent().isSelectingTileWithStack())
	$UnitPanel/UnitDetails.text += "\n"
	if get_parent().getSelectedStack() != null:
		$UnitPanel/UnitDetails.text += get_parent().getSelectedStack().getDetails()


func revealUnitPanel():
	updateUnitDetails()
	unitPanelHidden = false
	$UnitPanel.rect_position.y = 0
	$UnitPanel/UnitButton.text = "^^^"


func hideUnitPanel():
	unitPanelHidden = true
	$UnitPanel.rect_position.y = -122
	$UnitPanel/UnitButton.text = "vvv"


func _on_UnitMoveButton_pressed():
	get_parent().moveUnitPressed()
