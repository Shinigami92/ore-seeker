class_name Player
extends CharacterBody2D

signal carried_dirithium_changed(new_value: int)

@export var speed: float = 300.0

var weapon: Node2D

var carried_dirithium: int = 0


func _ready():
	var revolver_scene = load("res://weapons/revolver/revolver.tscn")
	weapon = revolver_scene.instantiate()
	add_child(weapon)


func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

	if weapon != null and Input.is_action_pressed("shoot"):
		weapon.shoot()


func _physics_process(_delta):
	get_input()
	move_and_slide()
