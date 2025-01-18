extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D
@onready var debug_info: Control = $DebugInfo
@onready var lantern: OmniLight3D = $Lantern


@export var mouse_sensitivity_h := 0.15
@export var mouse_sensitivity_v := 0.15

@export var canJump := false
@export var canUseLight := false
@export var canDropPaper := false

var isInDialog := false

var underwater := false

@export var speed = 5
const JUMP_VELOCITY = 4.5
@export var gravity := Vector3(0, -9.8, 0)

signal collidingWithCharacter(character)
signal interactedWithDoor()
signal interactedWithObject(currentCollider)

signal droppedPage(position)

func _ready():
	# hides debug info and connects dialog manager to endDialog() 
	$DebugInfo.hide()
	DialogueManager.dialogue_ended.connect(self.endDialog)
	pass

func _input(event):
	#checks if game has started or if currently in dialog, if true, dont process input
	if !StartedGame.startedGame:
		return
	if isInDialog:
		return
	if Global.isInCutscene:
		return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90)
	
	# if debug mode on, go to test room when pressing T
	if Global.debug:
		if Input.is_action_just_pressed("gotoTestRoom"):
			get_tree().change_scene_to_file("res://environment/maps/test_room.tscn")
	
	# calls pause and updates global var paused to true
	if Input.is_action_just_pressed("pause"):
		pause()
		Paused.pause.emit()
	
	if Input.is_action_just_pressed("dropPaper"):
		if canDropPaper:
			droppedPage.emit(position)
		elif Global.debug:
			droppedPage.emit(position)
		else:
			return
	
	if Input.is_action_just_pressed("light"):
		if canUseLight:
			var lightOn = lantern.visible
			if !lightOn:
				$Lantern/TurnOnLight.play()
				lantern.show()
			else:
				$Lantern/TurnOffLight.play()
				lantern.hide()
		else: 
			return
	
	# enables debug features like showing fps, collision states, and fullscreen status
	#if Input.is_action_just_pressed("debug_enable"):
		#var debugStatus = Global.debug
		#if debugStatus:
			#Global.debug = false
			##canJump = false
			##canDropPaper = false
			##canUseLight = false
			#print("Debug mode: off")
		#else:
			#Global.debug = true
			##canJump = true
			##canDropPaper = true
			##canUseLight = true
			#print("Debug mode: on")
	
	if Input.is_action_just_pressed("gotoMapChanger"):
		if Global.debug:
			get_tree().change_scene_to_file("res://environment/maps/map_changer.tscn")
		else:
			print("Debug Mode not enabled, enable by pressing Y")
			return
	
	if Input.is_action_just_pressed("reset"):
		if Global.debug:
			get_tree().reload_current_scene()
		else:
			print("Debug Mode not enabled, enable by pressing Y")
			return
		
	if Input.is_action_just_pressed("addThing"):
		if Global.debug:
			Global.thingsCollected += 1
		else:
			print("Debug Mode not enabled, enable by pressing Y")
			return

func _process(delta: float) -> void:
	if !StartedGame.startedGame:
		return
	
	# checks if debug mode enabled to show debug info
	if Global.debug:
		#print("debug enabled")
		debug_info.show()
		lantern.omni_range = 500
		lantern.light_energy = 16
		canJump = true
		canUseLight = true
	else:
		debug_info.hide()
		#canUseLight = false
		lantern.omni_range = 6
		lantern.light_energy = 1
	
	# runs raycast checks to see if colliding with interactables
	rayCastScans()


func _physics_process(delta: float) -> void:
	
	# no physics processing if game hasnt started or if in dialog
	if !StartedGame.startedGame:
		return
	
	if isInDialog:
		return
	
	if Global.debug:
		speed = 10.0
	else:
		speed = 5.0
	
	# add the gravity
	if not is_on_floor():
		if Global.isInCutscene:
				velocity.x = 0
				velocity.z = 0
				velocity += gravity/2 * delta
				move_and_slide()
		elif underwater:
			velocity += gravity/2 * delta
		else:
			velocity += gravity * delta
	
	if Global.isInCutscene:
		return
	
	# if jumping is enabled in this level allow it
	if canJump and Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y += 5
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()


## recieves from start button on game start, updates global startedGame var to true
func startGame():
	print("Game Start")
	StartedGame.startedGame = true

## pauses game and emits to UI manager that game should be paused
func pause():
	Paused.paused = true
	

## recieves from UI manager what the slider value for mouseSensitivity is, then passes it
func setMouseSensitivity(value: float):
	mouse_sensitivity_h = value/50
	mouse_sensitivity_v = value/50

## all logic for the players interaction with other objects via the interact button, E
func rayCastScans():
	
	# dont do anything if game hasnt started or if inside dialog
	if !StartedGame.startedGame:
		return
	
	if isInDialog:
		return
	
	if Global.isInCutscene:
		return
	
	$DebugInfo/InRangeOfCollider.hide()
	
	# gets what the raycast is colliding with
	var currentCollider = ray_cast_3d.get_collider()
	
	if ray_cast_3d.is_colliding():
		# if debug mode, show debug text for collisions
		if Global.debug:
			$DebugInfo/InRangeOfCollider.show()
		
		# check if focused object is a character
		if currentCollider.is_in_group("characters"):
			return
		
		# check if focused object is door, to run the door rigamarole
		elif currentCollider.is_in_group("doors"):
			if Input.is_action_just_pressed("interact"):
				interactedWithDoor.emit()
				return
			return
		
		# check if focused object is an object, if so when interacted
		# add to thingsCollected global (and prob do other stuff later)
		elif currentCollider.is_in_group("objects"):
			if Input.is_action_just_pressed("interact"):
				print("interacted with object")
				interactedWithObject.emit(currentCollider)
			return
		
		# check if focused object is papa, if so when interacted start papa dialogue
		elif currentCollider.is_in_group("papa"):
			if Input.is_action_just_pressed("interact"):
				isInDialog = true
				collidingWithCharacter.emit(currentCollider)
				return
		else:
			return

## ends dialogue when dialogue has ended (high level programming here)
func endDialog(_resource) -> void:
	print("exited dialogue")
	await get_tree().process_frame
	isInDialog = false
