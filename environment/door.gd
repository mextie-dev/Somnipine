extends Node3D

class_name Door

@export var location_scene : String
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal doorUsed

func interactedWith():
	Global.isInCutscene = true
	animation_player.play("open")
	doorUsed.emit()
