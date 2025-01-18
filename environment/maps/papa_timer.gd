extends Label

@onready var water_room: Node3D = $".."

func _process(_delta):
	text = "trigger: " + str(road_room.trigger)
	if Global.debug:
		show()
	else:
		hide()
	
