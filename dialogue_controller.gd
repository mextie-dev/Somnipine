extends Node2D

const BALLOON = preload("res://characters/dialog/dialogue_graphics/balloon.tscn")

@export var dialogueResource : DialogueResource
@export var dialogueStart : String = "start"

func startDialogue(character) -> void:
	var balloon := BALLOON.instantiate()
	get_tree().current_scene.add_child(balloon)
	dialogueStart = character
	balloon.start(dialogueResource, dialogueStart)
