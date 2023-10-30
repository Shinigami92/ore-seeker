class_name OuterWorldChunkGen
extends Marker2D

const CHUNK_SIZE = 16
const TILE_SIZE = 64
const CHUNK_WIDTH = CHUNK_SIZE * TILE_SIZE

@export var chunk_scene: PackedScene
@export var player: Player

var _chunks = {}


func _ready():
	pass


func _process(_delta):
	var player_chunk = Vector2i(floor(player.global_position / CHUNK_WIDTH))

	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var chunk_coord = player_chunk + Vector2i(dx, dy)
			if not _chunks.has(chunk_coord):
				print("Spawning chunk at ", chunk_coord)
				var chunk: Chunk = chunk_scene.instantiate()
				chunk.position = chunk_coord * CHUNK_WIDTH
				add_child(chunk)
				_chunks[chunk_coord] = chunk

	for chunk_coord in _chunks:
		if (chunk_coord - player_chunk).length() >= 3:
			print("Despawen chunk at ", chunk_coord)
			var chunk = _chunks.get(chunk_coord)
			if _chunks.erase(chunk_coord):
				chunk.queue_free()
