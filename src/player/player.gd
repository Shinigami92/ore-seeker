class_name Player
extends CharacterBody2D

signal carried_dirithium_changed(new_value: int)

@export var speed: float = 300.0

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
	velocity = input_direction * speed

	if weapon != null and Input.is_action_pressed("shoot"):
		weapon.shoot()


func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
