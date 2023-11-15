class_name EnemySpawner
extends Marker2D

const ENEMY_SCENE: PackedScene = preload("res://src/enemies/enemy.tscn")

@export var player: Player
@export var world: Node2D
@export var player_hub: PlayerHub

var random: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var spawn_interval_timer: Timer = $SpawnIntervalTimer


func _ready() -> void:
	player_hub.player_entered.connect(_on_player_entered_hub)
	player_hub.player_exited.connect(_on_player_exited_hub)
	spawn_interval_timer.timeout.connect(_spawn_enemy)


func _on_player_entered_hub() -> void:
	spawn_interval_timer.stop()


func _on_player_exited_hub() -> void:
	spawn_interval_timer.start()


func _spawn_enemy() -> void:
	var enemy: Enemy = ENEMY_SCENE.instantiate()
	enemy.target = player
	var side: int = random.randi_range(0, 3)
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
