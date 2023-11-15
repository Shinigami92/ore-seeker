class_name Enemy
extends CharacterBody2D

@export var movement_speed: float = 150.0

var start_navigating: bool = false
var target: Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var update_navigation_path_timer: Timer = $UpdateNavigationPathTimer


func _ready():
	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame

	start_navigating = true

	update_navigation_path_timer.timeout.connect(_update_navigation_path)
	#navigation_agent.waypoint_reached.connect(_update_navigation_path2)


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
	if not start_navigating or not target:
		return

	# target position
	var current_agent_position: Vector2 = global_position
	var next_path_position = navigation_agent.get_next_path_position()

	# velocity
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()


func _update_navigation_path():
	if not target:
		return

	navigation_agent.target_position = target.global_position


func take_damage():
	queue_free()
