class_name Chunk
extends Node2D

const CHUNK_SIZE = 16
const TILE_SIZE = 64
const CHUNK_WIDTH = CHUNK_SIZE * TILE_SIZE

@onready var tile_map: TileMap = $TileMap
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


static func instantiate(coordinated: Vector2i) -> Chunk:
	var chunk: Chunk = preload("res://src/world/chunks/chunk.tscn").instantiate()
	chunk.position = coordinated * CHUNK_WIDTH
	return chunk


func _ready() -> void:
	visibility_notifier.screen_entered.connect(tile_map.show)
	visibility_notifier.screen_exited.connect(tile_map.hide)

	# Stones
	for i in range(4):
		var atlas_coords: Vector2i = Vector2i(randi() % 8, randi() % 3)
		_place_random_cell(atlas_coords, 0)

	# Grass
	for i in range(6):
		var atlas_coords: Vector2i = Vector2i(randi() % 15, randi() % 6)
		_place_random_cell(atlas_coords, 1)

	# Flowers
	for i in range(2):
		var atlas_coords: Vector2i = Vector2i(randi() % 6, 6)
		_place_random_cell(atlas_coords, 1)

	tile_map.visible = false


func _place_random_cell(atlas_coords: Vector2i, source_id: int) -> void:
	var x: int = randi() % CHUNK_SIZE
	var y: int = randi() % CHUNK_SIZE
	var coords: Vector2i = Vector2i(x, y)
	tile_map.set_cell(0, coords, source_id, atlas_coords, 0)
