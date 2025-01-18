extends Node2D

@onready var change_to_water_room: Button = $ChangeToWaterRoom
@onready var change_to_road_room: Button = $ChangeToRoadRoom
@onready var change_to_test_room: Button = $ChangeToTestRoom
@onready var change_to_library_room: Button = $ChangeToLibraryRoom


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func changeToWaterRoom():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/water_room.tscn")

func changeToRoadRoom():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/road_room.tscn")


func changeToTestRoom():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/test_room.tscn")

func changeToLibrary():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/library_room.tscn")

func changeToDockRoom():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/dock_room.tscn")

func changeToRainyRoom():
	Global.thingsCollected = 1
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/rainy_room.tscn")

func changeToEndingRoomCutscene():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/ending_room_cutscene.tscn")

func changeToEndingRoom():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/ending_room.tscn")

func changeToCreditsRoom():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://environment/maps/credits_room.tscn")
