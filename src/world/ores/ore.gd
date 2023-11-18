class_name Ore
extends StaticBody2D

@export var amount_of_resources: int = 100

var is_depleted: bool = false

var _player_hub: PlayerHub
var _player_is_near: bool = false

var _miner: Miner = null

@onready var label: Label = $Label


static func instantiate(player_hub: PlayerHub) -> Ore:
	var ore: Ore = preload("res://src/world/ores/ore.tscn").instantiate()
	ore._player_hub = player_hub
	return ore


func _ready() -> void:
	label.text = "%d Dirithium" % amount_of_resources


func _physics_process(_delta: float) -> void:
	if _player_is_near and not _miner and Input.is_action_just_pressed("place_miner"):
		_miner = Miner.instantiate(self, _player_hub)
		add_child(_miner)
		_miner.tree_exiting.connect(_on_miner_tree_exiting)


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


func _on_miner_tree_exiting() -> void:
	_miner = null
