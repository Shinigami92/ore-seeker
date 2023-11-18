class_name Player
extends CharacterBody2D

signal carried_dirithium_changed(new_value: int)
signal died(player: Player)

@export var max_health: int = 3
@export var movement_speed: float = 300.0

var health: int = max_health

var weapon: Node2D = null

var carried_dirithium: int = 0


func _ready() -> void:
	var revolver_scene: PackedScene = load("res://src/weapons/revolver/revolver.tscn")
	weapon = revolver_scene.instantiate()
	add_child(weapon)


func get_input() -> void:
	var input_direction: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	velocity = input_direction * movement_speed

	if weapon != null and Input.is_action_pressed("shoot"):
		weapon.shoot()


func _physics_process(_delta: float) -> void:
	get_input()

	var collided: bool = move_and_slide()

	if collided:
		var collision: KinematicCollision2D = get_last_slide_collision()
		var collider: Object = collision.get_collider()

		if collider is Node2D:
			if collider.is_in_group("Enemy"):
				take_hit(collider)

				# Kill the enemy
				collider.take_damage(Enemy.MAX_HEALTH)


func take_hit(body: Node2D) -> void:
	# Currently this is always true, because there are only "Enemy"
	if body is Enemy:
		health -= body.damage

	if health <= 0:
		died.emit(self)
