class_name Ore
extends StaticBody2D

@export var miner_scene: PackedScene

var _miner: Miner = null
var _player_is_near: bool = false


func _physics_process(_delta):
	if _player_is_near and not _miner and Input.is_action_just_pressed("place_miner"):
		_miner = miner_scene.instantiate()
		add_child(_miner)


func _on_player_nearby_detector_body_entered(_body):
	_player_is_near = true


func _on_player_nearby_detector_body_exited(_body):
	_player_is_near = false
