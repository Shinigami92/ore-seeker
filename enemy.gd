class_name Enemy
extends CharacterBody2D

@export var movement_speed: float = 150.0

var start_navigating: bool = false

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = %Player


func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame

	start_navigating = true


func _physics_process(_delta):
	if not start_navigating:
		return

	# target position
	var current_agent_position: Vector2 = global_position
	navigation_agent.target_position = player.position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	# look at
	$AnimatedSprite2D.flip_h = global_position.x < player.global_position.x

	# velocity
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()


func take_damage():
	queue_free()
