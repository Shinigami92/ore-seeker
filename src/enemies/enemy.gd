class_name Enemy
extends CharacterBody2D

const MAX_HEALTH: int = 12

@export var movement_speed: float = 150.0

# The amount of damage the enemy will deal to the player
# This could be higher for enemies that are more dangerous
@export var damage: int = 1

var target: Node2D = null

var last_position: Vector2
var stuck_counter: int = 0

var health: int = MAX_HEALTH

var _player_hub: PlayerHub

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stuck_timer: Timer = $StuckTimer


static func instantiate(player_hub: PlayerHub) -> Enemy:
	var enemy: Enemy = preload("enemy.tscn").instantiate()
	enemy._player_hub = player_hub
	return enemy


func _ready() -> void:
	stuck_timer.timeout.connect(_on_stuck_timer_timeout)

	_player_hub.player_entered.connect(_on_player_hub_player_entered)


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
			take_damage(MAX_HEALTH)
	else:
		stuck_counter = 0

	last_position = global_position


func _on_player_hub_player_entered() -> void:
	# Despawn the enemy when the player enters the player hub
	queue_free()


# TODO christopher 2023-11-18: Either define another method that kills
# the enemy immediately due to game mechanics like player hitted or got stuck
# or redefine the argument(s) of this method to be more generic
# Latter might be better, allowing a DamageInfo object to be passed
func take_damage(damage: int) -> void:
	# Create a damage indicator
	var damage_indicator: DamageIndicator = (
		preload("res://src/effects/damage_indicator/damage_indicator.tscn").instantiate()
	)
	get_tree().root.add_child(damage_indicator)
	damage_indicator.global_position = global_position
	damage_indicator.label.text = str(damage)

	# Color the damage indicator as critical if the enemy is about to die
	if damage >= health:
		damage_indicator.label.modulate = Color.YELLOW

	# Reduce the enemy's health
	health -= damage

	if health <= 0:
		# Remove the enemy from the scene tree
		queue_free()
