class_name Enemy
extends CharacterBody2D

@export var movement_speed: float = 150.0

var target: Node2D = null
var last_position: Vector2
var stuck_counter: int = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stuck_timer: Timer = $StuckTimer


func _ready() -> void:
	stuck_timer.timeout.connect(_on_stuck_timer_timeout)


func _process(_delta: float) -> void:
	animated_sprite.flip_h = global_position.x < target.global_position.x


func _physics_process(_delta: float) -> void:
	if not target:
		return

	var new_velocity: Vector2 = target.global_position - global_position
	new_velocity = new_velocity.normalized() * movement_speed

	velocity = new_velocity
	move_and_slide()


func _on_stuck_timer_timeout() -> void:
	# Check if the enemy is stuck by comparing its current position to its last position
	# If the enemy has not moved for 3 seconds, it will take damage
	# This is to prevent enemies from getting stuck on walls

	if not last_position:
		last_position = global_position
		return

	if last_position.distance_to(global_position) < 4.0:
		stuck_counter += 1

		if stuck_counter >= 3:
			take_damage()
	else:
		stuck_counter = 0

	last_position = global_position


func take_damage() -> void:
	queue_free()
