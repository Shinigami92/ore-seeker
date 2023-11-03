class_name Bullet
extends Area2D

@export var speed: float = 700.0

@onready var life_span_timer: Timer = $LifeSpanTimer


func _ready():
	life_span_timer.timeout.connect(_on_life_span_timer_timeout)
	life_span_timer.start()


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_life_span_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()

	queue_free()
