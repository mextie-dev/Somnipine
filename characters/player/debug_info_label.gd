extends Control

@onready var player: CharacterBody3D = $".."


@onready var in_range_of_collider: Label = $InRangeOfCollider
@onready var fps_label: Label = $FPSLabel
@onready var things_collected: Label = $ThingsCollected
@onready var is_fullscreen: Label = $IsFullscreen
@onready var is_in_cut_scene: Label = $IsInCutScene
@onready var coordinates: Label = $Coordinates



func _process(_delta: float) -> void:
	fps_label.text = ""
	fps_label.text += "fps: " + str(Engine.get_frames_per_second())
	things_collected.text = "things_collected: " + str(Global.thingsCollected) + "/4"
	is_fullscreen.text = "fullscreen_mode: " + str(DisplayServer.window_get_mode())
	is_in_cut_scene.text = "is_in_cut_scene: " + str(Global.isInCutscene)
	coordinates.text = "xyz: " + str(str(int(player.global_position.x)) + ", " + str(int(player.global_position.y)) + ", " + str(int(player.global_position.z)))
