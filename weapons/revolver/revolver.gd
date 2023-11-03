class_name Revolver
extends Node2D

const BULLET_SCENE: PackedScene = preload("res://weapons/bullet.tscn")

@onready var shoot_interval_timer: Timer = $ShootIntervalTimer
@onready var reload_interval_timer: Timer = $ReloadIntervalTimer


func shoot():
	if not shoot_interval_timer.is_stopped():
		return

	shoot_interval_timer.start()

	var bullet = BULLET_SCENE.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.look_at(get_global_mouse_position())
