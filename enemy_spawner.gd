class_name EnemySpawner
extends Marker2D

@export var player: Player
@export var world: Node2D
@export var enemy_scene: PackedScene

var random = RandomNumberGenerator.new()

@onready var spawn_timer: Timer = $Timer


func _ready():
	spawn_timer.timeout.connect(_spawn_enemy)


func _spawn_enemy():
	var enemy: Enemy = enemy_scene.instantiate()
	var side = random.randi_range(0, 3)
	var vec: Vector2
	match side:
		# top
		0:
			vec = Vector2(random.randf_range(-960, 960), 540)
		# right
		1:
			vec = Vector2(960, random.randf_range(-540, 540))
		# bottom
		2:
			vec = Vector2(random.randf_range(-960, 960), -540)
		# left
		3:
			vec = Vector2(-960, random.randf_range(-540, 540))
	enemy.global_position = player.global_position + vec
	world.add_child(enemy)
