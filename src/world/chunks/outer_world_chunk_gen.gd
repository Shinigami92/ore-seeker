class_name OuterWorldChunkGen
extends Marker2D

const CHUNK_SIZE = 16
const TILE_SIZE = 64
const CHUNK_WIDTH = CHUNK_SIZE * TILE_SIZE
const CHUNK_SCENE: PackedScene = preload("res://src/world/chunks/chunk.tscn")

@export var player: Player

var _chunks: Dictionary = {}

@onready var chunk_generation_timer: Timer = $ChunkGenerationTimer

# TODO @Shinigami92 2023-11-14: https://dennissmuda.com/blog/godot-chunking-tutorial


func _ready():
	chunk_generation_timer.timeout.connect(_on_chunk_generation_timer_timeout)


func _on_chunk_generation_timer_timeout():
	var player_chunk = Vector2i(floor(player.global_position / CHUNK_WIDTH))

	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var chunk_coord = player_chunk + Vector2i(dx, dy)

			if not _chunks.has(chunk_coord):
				var chunk: Chunk = _create_chunk(chunk_coord)
				_chunks[chunk_coord] = chunk
				call_deferred("add_child", chunk)

	for chunk_coord in _chunks:
		if (chunk_coord - player_chunk).length() >= 8:
			var chunk = _chunks.get(chunk_coord)

			if _chunks.erase(chunk_coord):
				chunk.call_deferred("queue_free")


func _create_chunk(chunk_coord: Vector2i) -> Chunk:
	var chunk: Chunk = CHUNK_SCENE.instantiate()
	chunk.position = chunk_coord * CHUNK_WIDTH
	return chunk
