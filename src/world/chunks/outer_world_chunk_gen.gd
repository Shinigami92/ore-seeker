class_name OuterWorldChunkGen
extends Marker2D

const CHUNK_SIZE = 16
const TILE_SIZE = 64
const CHUNK_WIDTH = CHUNK_SIZE * TILE_SIZE
const CHUNK_SCENE: PackedScene = preload("res://src/world/chunks/chunk.tscn")

@export var player: Player

var _chunks: Dictionary = {}


func _process(_delta: float) -> void:
	var player_chunk: Vector2i = Vector2i(floor(player.global_position / CHUNK_WIDTH))

	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var chunk_coord: Vector2i = player_chunk + Vector2i(dx, dy)

			if not _chunks.has(chunk_coord):
				var chunk: Chunk = CHUNK_SCENE.instantiate()
				chunk.position = chunk_coord * CHUNK_WIDTH
				add_child(chunk)
				_chunks[chunk_coord] = chunk

	for chunk_coord in _chunks:
		if (chunk_coord - player_chunk).length() >= 3:
			var chunk: Chunk = _chunks.get(chunk_coord)

			if _chunks.erase(chunk_coord):
				chunk.queue_free()
