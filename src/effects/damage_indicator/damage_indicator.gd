class_name DamageIndicator
extends Node2D

@export var speed: float = 30.0
@export var friction: float = 15.0

var shift_direction: Vector2 = Vector2.ZERO

@onready var label: Label = $Label


func _ready() -> void:
	shift_direction = Vector2.from_angle(randf_range(0, 2 * PI))


func _process(delta: float) -> void:
	global_position += shift_direction * speed * delta
	speed = max(speed - friction * delta, 0)
