extends Camera2D



var holding = false




func _input(event):
	if event.is_action_pressed("rclick"):
		holding = true
	if event.is_action_released("rclick"):
		holding = false

	if event is InputEventMouseMotion:
		if holding:
			global_position += event.relative * -1
	
	if event.is_action_pressed("mwheelUp"):
		zoom *= 0.9
	if event.is_action_pressed("mwheelDown"):
		zoom *= 1.1
