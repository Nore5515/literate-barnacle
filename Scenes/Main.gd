extends Node2D




func _input(event):
	if event.is_action_pressed("click"):
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
	
	if event.is_action_pressed("esc"):
		$CanvasLayer/DetailPanel.visible = false
		$Highlight.visible = false
