extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var papa: Node3D = $Papa
@onready var show_papa_timer: Timer = $Papa / showPapaTimer
@onready var door: Door = $Door

var canSeePapa := false

var shadersLoaded := false

func _ready()->void :
	compileShaders()
	door.hide()
	papa.process_mode = Node.PROCESS_MODE_DISABLED
	door.process_mode = Node.PROCESS_MODE_DISABLED
	papa.hide()
	StartedGame.startButtonPressed.connect(startPapaTimer)
	StartedGame.startButtonPressed.connect(showInteractText)



func _process(delta: float)->void :
	$Papa / PapaTimer.text = "show_papa_timer: " + str(int(show_papa_timer.time_left))
	if Global.debug:
		$Papa / PapaTimer.show()
	else: 
		$Papa / PapaTimer.hide()

func startPapaTimer():
	print("started papa timer")
	show_papa_timer.start()

func showInteractText():
	if StartedGame.startedGame:
		animation_player.play("fadeInInteractText")
	else:
		return 

func showPapa():
	await get_tree().process_frame
	print(canSeePapa)
	if canSeePapa:
		show_papa_timer.start(5)
		return
	if !canSeePapa:
		papa.process_mode = Node.PROCESS_MODE_INHERIT
		$Papa/StaticBody3D/CollisionShape3D.disabled = false
		await get_tree().process_frame
		papa.show()

func isPapaVisible():
	if canSeePapa:
		canSeePapa = false
	else:
		canSeePapa = true

func talkedToPapa():
	door.process_mode = Node.PROCESS_MODE_INHERIT
	door.show()
	pass

func exit():
	animation_player.play("exitRoom")
	$AnimationPlayer / exitRoomTimer.start()

func changeScene():
	get_tree().change_scene_to_file("res://environment/maps/road_room.tscn")

func compileShaders():
	shadersLoaded = true
	var shaders = load("res://environment/maps/shader_preloads.tscn").instantiate()
	add_child(shaders)
	shaders.call_deferred("queue_free")
