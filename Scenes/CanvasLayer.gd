extends CanvasLayer


var econPanelHidden = true
var controlPanelHidden = false


func updateDetails(title, desc):
	if $DetailPanel.visible == false:
		$DetailPanel.visible = true
	$DetailPanel/TileName.text = title
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

##############


func _on_EndTurnButton_pressed():
	get_parent().endTurn()


func _on_BuildCityButton_pressed():
	get_parent().buildCityPressed()
