class_name TimeLeftIndicator
extends Label

@onready var timer: Timer = $Timer


func _process(_delta: float) -> void:
	text = "%02d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]


func _on_player_hub_player_exited() -> void:
	timer.start(300)
	visible = true


func _on_player_hub_player_entered() -> void:
	timer.stop()
	visible = false
