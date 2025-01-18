extends Node3D

func _ready() -> void:
	get_window().content_scale_factor = 1.0

func exitCutsene(scene):
	if scene == "cutscene":
		get_tree().change_scene_to_file("res://environment/maps/ending_room.tscn")
