extends Node3D

@onready var bell_sound: AudioStreamPlayer3D = $BellRinger1/BellSound
@onready var bell_sound_2: AudioStreamPlayer3D = $BellRinger2/BellSound2
@onready var bell_sound_3: AudioStreamPlayer3D = $BellRinger3/BellSound3

@onready var bell_push_normal: AnimationPlayer = $BellRinger1/bell_push_normal
@onready var bell_push_high: AnimationPlayer = $BellRinger2/bell_push_high
@onready var bell_push_low: AnimationPlayer = $BellRinger3/bell_push_low

@onready var wrong_sequence: AudioStreamPlayer3D = $WrongSequence


signal correctSequenceInput

var correctSequence = [2, 3, 1, 3]
var currentSequence = []

func _process(delta: float) -> void:
	var currentSequenceSize = currentSequence.size()
	if currentSequenceSize == 4:
		checkSequence(currentSequence)

func ringBell(object):
	if object.is_in_group("bellRingerOne"):
		var thisBellValue = 1
		bell_sound.play()
		bell_push_normal.play("push_normal")
		currentSequence.append(thisBellValue)
		print(currentSequence)
	if object.is_in_group("bellRingerTwo"):
		var thisBellValue = 2
		bell_sound_2.play()
		bell_push_high.play("push_high")
		currentSequence.append(thisBellValue)
		print(currentSequence)
	if object.is_in_group("bellRingerThree"):
		var thisBellValue = 3
		bell_push_low.play("push_low")
		bell_sound_3.play()
		currentSequence.append(thisBellValue)
		print(currentSequence)

func checkSequence(value):
	if value == correctSequence:
		print("successful puzzle")
		currentSequence.clear()
		bell_push_normal.play("hideAllButtons")
		correctSequenceInput.emit()
	else:
		print("wrong sequence! correct sequence %s, current sequence %s" % [correctSequence, currentSequence])
		wrong_sequence.play()
		currentSequence.clear()
