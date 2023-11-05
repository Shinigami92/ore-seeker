class_name Ore
extends StaticBody2D

@export var miner_scene: PackedScene
@export var amount_of_resources: int = 100

var is_depleted: bool = false

var _miner: Miner = null
var _player_is_near: bool = false

@onready var label: Label = $Label


func _ready():
	label.text = "%d Dirithium" % amount_of_resources


func _physics_process(_delta):
	if _player_is_near and not _miner and Input.is_action_just_pressed("place_miner"):
		_miner = miner_scene.instantiate()
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


func _on_player_nearby_detector_body_entered(_body):
	_player_is_near = true


func _on_player_nearby_detector_body_exited(_body):
	_player_is_near = false
