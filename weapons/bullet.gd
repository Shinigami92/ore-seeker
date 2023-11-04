class_name Bullet
extends Area2D

@export var speed: float = 700.0
@export var max_travel_distance: float = 500.0

var _traveled_distance: float = 0.0


func _physics_process(delta):
	_traveled_distance += speed * delta
	position += transform.x * speed * delta

	if _traveled_distance >= max_travel_distance:
		queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()

	queue_free()
