class_name OuterWorldChunkGen
extends Marker2D

@export var player: Player

var _chunks: Dictionary = {}


func _process(_delta: float) -> void:
	var player_chunk: Vector2i = Vector2i(floor(player.global_position / Chunk.CHUNK_WIDTH))

	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var chunk_coordinates: Vector2i = player_chunk + Vector2i(dx, dy)

			if not _chunks.has(chunk_coordinates):
				var chunk: Chunk = Chunk.instantiate(chunk_coordinates)
				add_child(chunk)
				_chunks[chunk_coordinates] = chunk

	for chunk_coordinates in _chunks:
		if (chunk_coordinates - player_chunk).length() >= 3:
			var chunk: Chunk = _chunks.get(chunk_coordinates)

			if _chunks.erase(chunk_coordinates):
				chunk.queue_free()
