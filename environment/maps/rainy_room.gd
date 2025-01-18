extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var papa: Node3D = $Papa
@onready var show_papa_timer: Timer = $Papa/showPapaTimer

var canSeePapa := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Door.process_mode = Node.PROCESS_MODE_DISABLED
	Global.isInCutscene = false
	papa.process_mode = Node.PROCESS_MODE_INHERIT
	papa.hide()
	player.lantern.omni_range = 500
	player.lantern.light_energy = 3
	$Papa/StaticBody3D/CollisionShape3D.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Papa/PapaTimer.text = "show_papa_timer: " + str(int(show_papa_timer.time_left))
	if Global.debug:
		$Papa/PapaTimer.show()

func isPapaVisible():
	if canSeePapa:
		canSeePapa = false
		print(canSeePapa)
	else:
		canSeePapa = true
		print(canSeePapa)

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

func hidePapa():
	if Global.choseEnding:
		papa.process_mode = Node.PROCESS_MODE_DISABLED
		$Door.process_mode = Node.PROCESS_MODE_INHERIT
		$Door.show()
		$Papa/StaticBody3D/CollisionShape3D.disabled = true
		await get_tree().process_frame
		
		papa.hide()
	else:
		return

func exit():
	animation_player.play("exitRoom")

func changeScene(anim):
	if anim == "exitRoom":
		get_tree().change_scene_to_file("res://environment/maps/ending_room_cutscene.tscn")
