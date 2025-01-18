extends Node

@onready var mouse_over_button: AudioStreamPlayer = $MouseOverButton
@onready var click_button: AudioStreamPlayer = $ClickButton
@onready var click_button_playing: AudioStreamPlayer = $ClickButton/ClickButtonPlaying
@onready var click_start: AudioStreamPlayer = $ClickStart
@onready var slider_clicks: AudioStreamPlayer = $SliderClicks

func playMouseOverButton():
	mouse_over_button.play()

func playClickButton():
	if click_button.playing:
		click_button_playing.play()
	else: 
		click_button.play()

func playClickStartButton():
	click_start.play()

func playSliderClicks():
	slider_clicks.play()
