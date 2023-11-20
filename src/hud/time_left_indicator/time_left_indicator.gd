class_name TimeLeftIndicator
extends Label

signal time_left_ended

## The time in seconds that the player has to complete the level.
@export var time: int = 300

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func _process(_delta: float) -> void:
	text = "%02d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]


func _on_player_hub_player_exited() -> void:
	timer.start(time)
	visible = true


func _on_player_hub_player_entered() -> void:
	timer.stop()
	visible = false


func _on_timer_timeout() -> void:
	time_left_ended.emit()
