extends Node3D

@onready var page: Decal = $Page

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	page.show()


func dropPage(position):
	var newPage = page.duplicate()
	add_child(newPage)
	newPage.position = position
	newPage.rotation.y = Global.rng.randf_range(0, 360)
	$DroppingPageSound.pitch_scale = Global.rng.randf_range(0.9, 1.1)
	$DroppingPageSound.play()
