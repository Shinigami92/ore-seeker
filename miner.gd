class_name Miner
extends Area2D

var placed_on: Ore
var mined_amount: int = 0

@onready var mining_interval_timer: Timer = $MiningIntervalTimer
@onready var progress: ProgressBar = $MiningProgressBar


func init(placed_on: Ore):
	self.placed_on = placed_on


func _ready():
	mining_interval_timer.timeout.connect(_on_mining_interval_timer)


func _on_mining_interval_timer():
	if not placed_on.is_depleted:
		mined_amount += placed_on.gain_resource()
		progress.value = mined_amount
