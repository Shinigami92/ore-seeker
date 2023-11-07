class_name PlayerHub
extends Node2D

signal player_exited
signal player_entered

var _x: float

@onready var player_door_detector = $PlayerDoorDetector


func _ready():
	_x = (
		player_door_detector.global_position.x
		+ player_door_detector.get_node("CollisionShape2D").shape.get_rect().size.x / 2
	)


func _on_area_2d_body_exited(body: Node2D):
	if body is Player:
		if body.global_position.x > _x:
			player_exited.emit()
		else:
			player_entered.emit()
