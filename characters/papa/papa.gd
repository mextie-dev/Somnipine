extends Node3D

const BALLOON = preload("res://characters/dialog/dialogue_graphics/balloon.tscn")

@export var dialogueResource : DialogueResource
@export var dialogueStart : String = "start"

signal firstTalkedToPapa


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func startDialogue(character) -> void:
	var balloon := BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogueResource, dialogueStart)
	firstTalkedToPapa.emit()
