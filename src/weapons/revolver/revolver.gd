class_name Revolver
extends Node2D

@export var max_ammo: int = 6

var ammo: int = max_ammo

@onready var shoot_interval_timer: Timer = $ShootIntervalTimer
@onready var reload_interval_timer: Timer = $ReloadIntervalTimer


func shoot() -> void:
	if ammo < 0 or not reload_interval_timer.is_stopped() or not shoot_interval_timer.is_stopped():
		return

	shoot_interval_timer.start()

	var bullet: Bullet = Bullet.instantiate()
	bullet.global_position = global_position
	get_tree().root.add_child(bullet)
	bullet.look_at(get_global_mouse_position())

	ammo -= 1

	if ammo <= 0:
		reload()


func reload() -> void:
	if not reload_interval_timer.is_stopped():
		return

	reload_interval_timer.start()

	ammo = max_ammo
