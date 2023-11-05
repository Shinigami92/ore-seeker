class_name Miner
extends Area2D

var placed_on: Ore
var mined_amount: int = 0

@onready var mining_interval_timer: Timer = $MiningIntervalTimer
@onready var mining_progress_bar: ProgressBar = $MiningProgressBar
@onready var label: Label = $Label


func init(placed_on: Ore):
	self.placed_on = placed_on


func _ready():
	mining_interval_timer.timeout.connect(_on_mining_interval_timer)
	mining_progress_bar.max_value = mining_interval_timer.wait_time

	_redraw_label()


func _process(_delta):
	if placed_on.is_depleted:
		mining_interval_timer.stop()
		mining_progress_bar.value = 0
		set_process(false)
	else:
		mining_progress_bar.value = mining_interval_timer.time_left


func _on_mining_interval_timer():
	if not placed_on.is_depleted:
		mined_amount += placed_on.gain_resource()
		_redraw_label()


func _on_body_entered(body: Node):
	if body is Player:
		body.carried_dirithium += mined_amount
		body.carried_dirithium_changed.emit(body.carried_dirithium)
		mined_amount = 0
		_redraw_label()


func _redraw_label():
	label.text = "%d Dirithium" % mined_amount
