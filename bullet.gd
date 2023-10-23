extends Area2D

@export var speed: float = 700.0
@onready var timer: Timer = %Timer


func _ready():
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()

	queue_free()
