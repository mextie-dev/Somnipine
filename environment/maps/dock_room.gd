extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var world_environment: WorldEnvironment = $WorldEnvironment

var currentSkyColor : Color
var currentFogColor : Color

var currentFogDepth = 15

var playingMusic := false

var isUnderwater := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fadeIn")
	await get_tree().create_timer(5).timeout
	Global.isInCutscene = false
	currentSkyColor = world_environment.environment.background_color
	currentFogColor = world_environment.environment.fog_light_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isUnderwater:
		changeSkyColor()
	else:
		pass

func playMusic(body):
	if playingMusic:
		return

	if body == player:
		print("playing music")
		$AudioManager/Song.play()
		playingMusic = true
		
	

func fadeInFog(body):
	if body == player:
		var tween = get_tree().create_tween()
		tween.tween_property(world_environment.environment, "fog_depth_end", 50, 5)
	
func fadeOutFog(body):
	if body == player:
		var tween = get_tree().create_tween()
		tween.tween_property(world_environment.environment, "fog_depth_end", 15, 5)
		

func jumpedIntoWater(body):
	if body == player:
		$AudioManager/EnterWater.play()
		player.underwater = true
		Global.isInCutscene = true
		player.underwater = true
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(world_environment.environment, "fog_depth_end", 0.01, 0.3)
		tween.tween_property(world_environment.environment, "fog_light_color", Color("004380"), 5)
		tween.tween_property(world_environment.environment, "background_color", Color("004380"), 5)
		print("entering the depths")

func hitBottom(body):
	if isUnderwater:
		return
	if body == player:
		$AboveFloor.hide()
		Global.isInCutscene = false
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(world_environment.environment, "fog_depth_end", 20, 5)
		tween.tween_property(world_environment.environment, "fog_depth_begin", 10, 5)
		tween.tween_property(world_environment.environment, "fog_height", 0, 5)
		tween.tween_property(world_environment.environment, "fog_height_density", 0, 5)
		isUnderwater = true
		print("hit bottom")
		

func aboveWater(body):
	if body == player:
		print("above water")
		$AudioManager/ExitWater.play()
		isUnderwater = false
		player.underwater = false

func underwaterFailsafe(body):
	if body == player:
		isUnderwater = true
		player.underwater = true

func changeSkyColor():
	currentSkyColor.r = player.position.y / 150 + 0
	currentSkyColor.g = player.position.y / 150 + 0.2627
	currentSkyColor.b = player.position.y / 150 + 0.5019
	world_environment.environment.background_color = currentSkyColor
	world_environment.environment.fog_light_color = currentSkyColor

func exitArea():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(world_environment.environment, "fog_depth_end", 0.01, 7)
	tween.tween_property(world_environment.environment, "fog_light_color", Color("000000"), 7)
	tween.tween_property(world_environment.environment, "background_color", Color("000000"), 7)
	await get_tree().create_timer(12).timeout
	get_tree().change_scene_to_file("res://environment/maps/rainy_room.tscn")
