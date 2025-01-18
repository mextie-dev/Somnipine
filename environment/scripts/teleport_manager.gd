extends Node3D

@onready var player: CharacterBody3D = $"../Player"


@onready var teleport_z_forward_point: Marker3D = $TeleportZForward/TeleportZForwardPoint

@onready var teleport_z_backward_point: Marker3D = $TeleportZBackward/TeleportZBackwardPoint

@onready var teleport_x_forward_point: Marker3D = $TeleportXForward/TeleportXForwardPoint

@onready var teleport_x_backward_point: Marker3D = $TeleportXBackward/TeleportXBackwardPoint

## teleport player along z forward
func zForward(body):
	
	if body == player:
		player.global_position = teleport_z_forward_point.get_global_transform().origin
	

## teleport player along z backward
func zBackward(body):
	
	if body == player:
		player.global_position = teleport_z_backward_point.get_global_transform().origin

## teleport player along x forward
func xForward(body):
	
	if body == player:
		player.global_position = teleport_x_forward_point.get_global_transform().origin
	

## teleport player along x backward
func xBackward(body):
	
	if body == player:
		player.global_position = teleport_x_backward_point.get_global_transform().origin
	
