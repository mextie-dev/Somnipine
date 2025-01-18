extends MeshInstance3D

@onready var timer: Timer = $Timer
@onready var area_3d: Area3D = $Area3D
@onready var label: Label = $Label
@onready var player: CharacterBody3D = $"../Player"

func _process(_delta: float) -> void:
	label.text = "cutscene left: " + str(timer.time_left)

func startCutscene(body):
	if body == player:
		print("cutscene started")
		Global.isInCutscene = true
		label.show()
		timer.start()
	

func endCutscene():
	print("cutscene ended")
	timer.stop()
	label.hide()
	area_3d.set_deferred("monitoring", false)
	Global.isInCutscene = false
