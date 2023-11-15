class_name Ore
extends StaticBody2D

const MINER_SCENE: PackedScene = preload("res://src/miners/miner.tscn")

@export var amount_of_resources: int = 100

var is_depleted: bool = false

var _miner: Miner = null
var _player_is_near: bool = false

@onready var label: Label = $Label


func _ready() -> void:
	label.text = "%d Dirithium" % amount_of_resources


func _physics_process(_delta: float) -> void:
	if _player_is_near and not _miner and Input.is_action_just_pressed("place_miner"):
		_miner = MINER_SCENE.instantiate()
		_miner.init(self)
		add_child(_miner)


func gain_resource(take: int = 1) -> int:
	if not is_depleted:
		amount_of_resources -= take

		if amount_of_resources <= 0:
			is_depleted = true
			take += amount_of_resources
			amount_of_resources = 0

		label.text = "%d Dirithium" % amount_of_resources

		return take

	return 0


func _on_player_nearby_detector_body_entered(_body: Node2D) -> void:
	_player_is_near = true


func _on_player_nearby_detector_body_exited(_body: Node2D) -> void:
	_player_is_near = false
