extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var rain_slowdown: Area3D = $Rain/RainSlowdown
@onready var rain: GPUParticles3D = $Rain
@onready var rain_slowdown_animation: AnimationPlayer = $Rain/RainSlowdownAnimation
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var world_environment: WorldEnvironment = $WorldEnvironment

var skyColor : Color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.isInCutscene = false
	skyColor = world_environment.environment.background_color
	skyColor = Color(255, 255, 255)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	changeSkyColorHeight()

func slowDownRain(body):
	if body == player:
		rain_slowdown_animation.play("slowDownRain")
		animation_player.play("darkenWorld")

func speedUpRain(body):
	if body == player:
		rain_slowdown_animation.play_backwards("slowDownRain")
		animation_player.play_backwards("darkenWorld")
		

func changeSkyColorHeight():
	skyColor.r = player.position.y / 3 + 2
	skyColor.g = player.position.y / 3 + 2
	skyColor.b = player.position.y / 3 + 2
	world_environment.environment.background_color = skyColor
