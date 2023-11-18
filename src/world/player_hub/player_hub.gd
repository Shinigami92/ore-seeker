class_name PlayerHub
extends Node2D

signal player_exited
signal player_entered

var _door_offset_x: float

@onready var player_door_detector: Area2D = $PlayerDoorDetector


func _ready() -> void:
	_door_offset_x = (
		player_door_detector.global_position.x
		+ player_door_detector.get_node("CollisionShape2D").shape.get_rect().size.x / 2
	)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		if body.global_position.x > _door_offset_x:
			player_exited.emit()
		else:
			player_entered.emit()


func _on_player_died(player: Player) -> void:
	# TODO christopher 2023-11-18: Define respawn marker
	player.global_position = global_position

	player.health = player.max_health

	player_entered.emit()
