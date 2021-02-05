extends CanvasLayer





func updateDetails(title, desc):
	if $DetailPanel.visible == false:
		$DetailPanel.visible = true
	$DetailPanel/TileName.text = title
	$DetailPanel/TileDetails.text = desc
