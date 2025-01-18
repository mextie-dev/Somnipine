extends Node2D

@onready var options: Control = $Options
@onready var main_controls: Control = $MainControls
@onready var back: Button = $Back
@onready var back_from_pause: Button = $BackFromPause
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_out_timer: Timer = $AnimationPlayer/FadeOutTimer
@onready var start_button: Button = $MainControls/StartButton
@onready var title: Label = $AmbienTitle


var defaultSensitivity = 1
var defaultVolume = 70

signal startGame
signal giveMouseSensitivity(value: float)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mouseSensitivity = defaultSensitivity
	Global.audioVolume = defaultVolume
	if StartedGame.startedGame:
		title.hide()
		main_controls.hide()
		options.hide()
		animation_player.play("HIDEALL")
		return
	main_controls.show()
	options.hide()
	$Options/MouseSens/MouseSensSlider.value = Global.mouseSensitivity * 50
	$Options/AudioVolume/AudioVolumeSlider.value = Global.audioVolume

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Paused.paused:
		animation_player.play("RESET")
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		main_controls.hide()
		show()
		showPauseScreen()

func enterOptions():
	main_controls.hide()
	back.show()
	options.show()

func exitOptions():
	main_controls.show()
	back.hide()
	options.hide()

func startPressed():
	startGame.emit()
	StartedGame.startButtonPressed.emit()
	start_button.release_focus()
	animation_player.play("fadeOut")
	fade_out_timer.start()

func hideAll():
	back.hide()
	main_controls.hide()
	hide()

func showPauseScreen():
	animation_player.play("RESET")
	options.show()
	back_from_pause.show()

func exitOptionsFromPause():
	Paused.paused = false
	options.hide()
	back_from_pause.hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()

func quit():
	get_tree().quit()

func fullscreen():
	var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func setMouseSensitivity(value: float):
	Global.mouseSensitivity = value
	print("Raw Mouse Sensitivity: %s, Parsed: %s" % [Global.mouseSensitivity, Global.mouseSensitivity/50])
	giveMouseSensitivity.emit(Global.mouseSensitivity)
	
func setMasterAudioVolume(value: float):
	Global.audioVolume = value - 70
	print(Global.audioVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Global.audioVolume)
