extends TileMap






func getTileAtPos(pos):
	var gridLoc = world_to_map(pos)
	
	return get_cellv(gridLoc)


func placeHighlightAtPos(pos):
	var highlight = get_parent().get_node("Highlight")
	if highlight.visible == false:
		highlight.visible = true
	var gridLoc = world_to_map(pos)
	highlight.global_position = map_to_world(gridLoc)
	
