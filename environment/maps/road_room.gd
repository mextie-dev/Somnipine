extends Node3D

var trigger := 0

@onready var bell: AudioStreamPlayer3D = $AudioManager/BellSound
@onready var bell2: AudioStreamPlayer3D = $AudioManager/BellSound2
@onready var bell3: AudioStreamPlayer3D = $AudioManager/BellSound3
@onready var bell4: AudioStreamPlayer3D = $AudioManager/BellSound4
@onready var bell_chorus: AudioStreamPlayer3D = $AudioManager/BellChorus

@onready var melody: AudioStreamPlayer3D = $AudioManager/Melody



@onready var wind_ambience: AudioStreamPlayer = $AudioManager/WindAmbience


@onready var castle_open: Node3D = $Walls/castle_open
@onready var castle_closed: MeshInstance3D = $Walls/CenterWall

@onready var outer_wall: Node3D = $Walls/OuterWall
@onready var outer_wall_shaded: Node3D = $Walls/OuterWallShaded


@onready var trigger_1: Area3D = $Puzzle/Trigger1
@onready var trigger_2: Area3D = $Puzzle/Trigger2
@onready var trigger_3: Area3D = $Puzzle/Trigger3
@onready var trigger_4: Area3D = $Puzzle/Trigger4

@onready var bell_ringers: Node3D = $Puzzle/BellRingers

@onready var player: CharacterBody3D = $Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var open_castle_timer: Timer = $Walls/openCastleTimer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.isInCutscene = true
	animation_player.play("fogFadeOut")
	bell_ringers.hide()
	bell_ringers.process_mode = Node.PROCESS_MODE_DISABLED
	#door.process_mode = Node.PROCESS_MODE_DISABLED
	#door.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startMap():
	Global.isInCutscene = false
	animation_player.play("fadeInJumpText")

func triggerOne(body):
	if body == player:
		if Global.debug:
			print("hit trigger one")
			print("Trigger 1 monitoring state is %s" % trigger_1.monitoring)
			print("Trigger 2 monitoring state is %s" % trigger_2.monitoring)
		
		trigger = 0
		trigger_1.hide()
		trigger_1.set_deferred("monitoring", false)
		trigger_2.monitoring = true
		trigger_2.show()
		trigger += 1
		
		bell.play()

func triggerTwo(body):
	if body == player:
		if Global.debug:
			print("hit trigger two")
			print("trigger 2 monitoring state is %s" % trigger_2.monitoring)
			print("Trigger 3 monitoring state is %s" % trigger_3.monitoring)
		
		trigger_2.hide()
		trigger_2.set_deferred("monitoring", false)
		trigger_3.monitoring = true
		trigger_3.show()
		trigger += 1
		
		bell2.play()

func triggerThree(body):
	if body == player:
		if Global.debug:
			print("hit trigger three")
			print("trigger 3 monitoring state is %s" % trigger_2.monitoring)
			print("Trigger 4 monitoring state is %s" % trigger_3.monitoring)
		
		trigger_3.hide()
		trigger_3.set_deferred("monitoring", false)
		trigger_4.monitoring = true
		trigger_4.show()
		trigger += 1
		
		bell3.play()

func triggerFour(body):
	if body == player:
		if Global.debug:
			print("hit trigger two")
			print("trigger 4 monitoring state is %s" % trigger_2.monitoring)
		
		trigger_4.hide()
		trigger_4.set_deferred("monitoring", false)
		trigger_1.monitoring = true
		trigger_1.show()
		trigger += 1
		
		bell4.play()
		
		bell_ringers.show()
		bell_ringers.process_mode = Node.PROCESS_MODE_INHERIT

func puzzleComplete():
	bell_chorus.play()
	animation_player.play_backwards("fogFadeOut")
	open_castle_timer.start()
	#door.show()
	#door.process_mode = Node.PROCESS_MODE_INHERIT
	trigger_1.process_mode = Node.PROCESS_MODE_DISABLED
	trigger_2.process_mode = Node.PROCESS_MODE_DISABLED
	trigger_3.process_mode = Node.PROCESS_MODE_DISABLED
	trigger_4.process_mode = Node.PROCESS_MODE_DISABLED

func openCastle():
	print("opened castle")
	animation_player.play("fogFadeOutExit")
	outer_wall.hide()
	outer_wall_shaded.show()
	castle_closed.hide()
	castle_closed.process_mode = Node.PROCESS_MODE_DISABLED
	castle_open.show()
	await get_tree().create_timer(5).timeout
	melody.play()

func exit(body):
	if body == player:
		animation_player.play("blackFogFadeIn")
		$AnimationPlayer/exitRoomTimer.start()

func changeScene():
	Global.isInCutscene = true
	get_tree().change_scene_to_file("res://environment/maps/library_room.tscn")
