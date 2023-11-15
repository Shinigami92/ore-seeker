class_name FPSCounter
extends Label

const INT64_MAX = (1 << 63) - 1  # 9223372036854775807

@export var sample_seconds: int = 10

var fps_samples: Array[float] = []
var min_fps: int = INT64_MAX
var max_fps: int = 0
var total_fps: int = 0
var current_fps: float = 0

var max_samples: int = 0


func _ready() -> void:
	max_samples = Engine.physics_ticks_per_second * sample_seconds


func _physics_process(_delta: float) -> void:
	current_fps = Engine.get_frames_per_second()

	total_fps += current_fps

	fps_samples.append(current_fps)

	while fps_samples.size() > max_samples:
		total_fps -= fps_samples[0]
		fps_samples.remove_at(0)

	min_fps = fps_samples.min()
	max_fps = fps_samples.max()

	_update_label()


func _update_label() -> void:
	text = (
		"FPS: %d | Min: %d | Max: %d | Avg: %d"
		% [current_fps, min_fps, max_fps, int(total_fps / fps_samples.size())]
	)
