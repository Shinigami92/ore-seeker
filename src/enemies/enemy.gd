class_name Enemy
extends CharacterBody2D

@export var movement_speed: float = 150.0

var start_navigating: bool = false
var target: Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame

	start_navigating = true


func _process(_delta):
	if not target:
		return

	# TODO @Shinigami92 2023-11-13: the look at is just a rendering nice-to-have
	# and so it does not need to be in a physics process
	# hoverer, the look at could be extracted into a component and then iterated
	# in an enemy manager and so it could be maybe a little bit more performant
	# but for now this works and is good enough

	# look at
	animated_sprite.flip_h = global_position.x < target.global_position.x


func _physics_process(_delta):
	if not start_navigating:
		return

	if not target:
		return

	# target position
	var current_agent_position: Vector2 = global_position
	navigation_agent.target_position = target.global_position
	# TODO @Shinigami92 2023-11-13: a call to `navigation_agent.get_next_path_position()`
	# is very expensive and only makes around 60 enemies possible
	# before calling it, the enemy could shoot a raycast to target and if it hits
	# the target, the enemy could just move in straight line to the target
	# and don't need to calculate a path
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position, target.global_position
	)
	var result: Dictionary = space_state.intersect_ray(query)

	var next_path_position: Vector2
	if result.collider == target:
		next_path_position = navigation_agent.target_position
	else:
		next_path_position = navigation_agent.get_next_path_position()

	# velocity
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()


func take_damage():
	queue_free()
