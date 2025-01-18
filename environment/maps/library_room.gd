extends Node3D

@onready var player: CharacterBody3D = $Player

@onready var floor_creak_sound_one: AudioStreamPlayer3D = $Jumpscares/FloorCreakOne/FloorCreakSound

@onready var book_drop_sound: AudioStreamPlayer3D = $Jumpscares/BookDropOne/BookDrop

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var running_jumpscare: AnimationPlayer = $Jumpscares/RunningOne/RunningJumpscare
@onready var running_two: Area3D = $Jumpscares/RunningTwo

@onready var pills: Node3D = $Exit/Pills


signal pressedMazeDoorOpenButton

var random

var mazeDoorOpened := false
var pickedUpPills := false
var showedInspectText := false

var floorCreakOneFired := false
var floorCreakTwoFired := false
var footstepsOneFired := false
var footstepsTwoFired := false
var pillsFired := false
var bookDropFired := false
var runningFired := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.isInCutscene = false
	$InspectShelfText.hide()
	
	$DropPagesText.hide()
	$Jumpscares/BookDropOne/book_brown/PickupBook.process_mode = Node.PROCESS_MODE_DISABLED
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	random = Global.rng.randf_range(-10.0, 10.0)

func showShelfInspectText(body):
	if mazeDoorOpened:
		return
	elif showedInspectText:
		return
	elif body == player:
		$InspectShelfText.show()
		await get_tree().create_timer(5).timeout
		$InspectShelfText.hide()
		showedInspectText = true
		

func pickupBook(body):
	if body == player:
		$Jumpscares/BookDropOne/book_brown.hide()
		$DropPagesText.show()
		player.canDropPaper = true
		await get_tree().create_timer(5).timeout
		$DropPagesText.hide()

# JUMPSCARES ---------------------------

func floorCreakOne(body):
	if floorCreakOneFired:
		return
	if body == player:
		if random >= 5:
			floor_creak_sound_one.play()
			floorCreakOneFired = true
		else:
			print("RNG did not hit for jumpscare, current rng: " + str(random))
			return

func bookDrop(body):
	if bookDropFired:
		return
	if body == player:
		book_drop_sound.play()
		$Jumpscares/BookDropOne/book_brown.show()
		$Jumpscares/BookDropOne/book_brown/PickupBook.process_mode = Node.PROCESS_MODE_INHERIT
		bookDropFired = true

func running(body):
	if runningFired:
		return
	if body == player:
		if random >= 2:
			running_jumpscare.play("runningJumpscare")
			player.canUseLight = false
			$Player/Lantern.hide()
			player.speed = 10
			runningFired = true
		else:
			return

func runningTwo(body):
	if runningFired:
		return
	if body == player:
		$Jumpscares/RunningTwo/RunningJumpscare.play("runningJumpscare")
		player.canUseLight = false
		$Player/Lantern.hide()
		player.speed = 10
		runningFired = true
	else:
		return

func enableLight(_value):
	print("re enabled light")
	player.speed = 5
	player.canUseLight = true

func playRainSounds(body):
	if body == player:
		$AudioManager/rainSounds.play()
		var tween = get_tree().create_tween()
		tween.tween_property($AudioManager/rainSounds, "volume_db", 0, 2)
		#tween.tween_callback($AudioManager/rainSounds.queue_free)

func stopRainSounds(body):
	if body == player:
		var tween = get_tree().create_tween()
		tween.tween_property($AudioManager/rainSounds, "volume_db", -80, 3)
		#tween.tween_callback($AudioManager/rainSounds.queue_free)

func openMazeDoor(object):
	if mazeDoorOpened:
		return
	
	if object.is_in_group("button"):
		pressedMazeDoorOpenButton.emit()
		print("exit button hit, something opened in the maze")
		animation_player.play("fadeInMazeOpenedText")
		var openPos = Vector3(0, 0, -5)
		$Floor/SecondFloor/Maze/bookshelf98.translate(openPos)
		running_two.process_mode = Node.PROCESS_MODE_INHERIT
		mazeDoorOpened = true

func pickupPills(object):
	if object.is_in_group("pills"):
		Global.isInCutscene = true
		player.canUseLight = false
		player.lantern.hide()
		$Player/Lantern/TurnOffLight.play()
		Global.thingsCollected += 1
		await get_tree().create_timer(2).timeout
		$Exit/Pills/AudioStreamPlayer3D.play()
		await get_tree().create_timer(8).timeout
		changeScene()


func changeScene():
	get_tree().change_scene_to_file("res://environment/maps/dock_room.tscn")
