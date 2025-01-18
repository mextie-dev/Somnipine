extends Node3D

@onready var player: CharacterBody3D = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.isInCutscene = false
	get_window().content_scale_factor = 1.0
	#player.mouse_sensitivity_h /= 7
	#player.mouse_sensitivity_v /= 7

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startEnding():
	get_tree().change_scene_to_file("res://environment/maps/credits_room.tscn")
