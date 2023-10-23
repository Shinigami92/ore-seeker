extends CharacterBody2D

@export var speed: float = 300.0
@export var bullet_scene: PackedScene


func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

	if Input.is_action_just_pressed("shoot"):
		shoot()


func _physics_process(_delta):
	get_input()
	move_and_slide()


func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.position = global_position
	bullet.look_at(get_global_mouse_position())
