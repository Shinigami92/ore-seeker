class_name Miner
extends Area2D

var _placed_on: Ore
var _player_hub: PlayerHub

var _mined_amount: int = 0

@onready var mining_interval_timer: Timer = $MiningIntervalTimer
@onready var mining_progress_bar: ProgressBar = $MiningProgressBar
@onready var label: Label = $Label


static func instantiate(placed_on: Ore, player_hub: PlayerHub) -> Miner:
	var miner: Miner = preload("res://src/miners/miner.tscn").instantiate()
	miner._placed_on = placed_on
	miner._player_hub = player_hub
	return miner


func _ready() -> void:
	mining_interval_timer.timeout.connect(_on_mining_interval_timer)
	mining_progress_bar.max_value = mining_interval_timer.wait_time

	_redraw_label()

	_player_hub.player_entered.connect(_on_player_hub_player_entered)


func _process(_delta: float) -> void:
	if _placed_on.is_depleted:
		mining_interval_timer.stop()
		mining_progress_bar.value = 0
		set_process(false)
	else:
		mining_progress_bar.value = mining_interval_timer.time_left


func _on_mining_interval_timer() -> void:
	if not _placed_on.is_depleted:
		_mined_amount += _placed_on.gain_resource()
		_redraw_label()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.carried_dirithium += _mined_amount
		body.carried_dirithium_changed.emit(body.carried_dirithium)
		_mined_amount = 0
		_redraw_label()


func _redraw_label() -> void:
	label.text = "%d Dirithium" % _mined_amount


func _on_player_hub_player_entered() -> void:
	# Despawn the miner when the player enters the player hub
	# Mined resources in the meantime will be lost on purpose
	queue_free()
