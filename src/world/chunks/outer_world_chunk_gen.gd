class_name OuterWorldChunkGen
extends Marker2D

@export var player: Player
@export var player_hub: PlayerHub

var _generation_active: bool = false
var _chunks: Dictionary = {}
var _noise: FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noise.fractal_octaves = 4
	_noise.frequency = 1.0 / 20.0


func _process(_delta: float) -> void:
	if not _generation_active:
		return

	var player_chunk: Vector2i = Vector2i(floor(player.global_position / Chunk.CHUNK_WIDTH))

	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var chunk_coordinates: Vector2i = player_chunk + Vector2i(dx, dy)

			if not _chunks.has(chunk_coordinates):
				var chunk: Chunk = Chunk.instantiate(chunk_coordinates, _noise, player_hub)
				add_child(chunk)
				_chunks[chunk_coordinates] = chunk


func _on_player_hub_player_exited() -> void:
	randomize()

	_noise.seed = randi()
	print("Seed: %d" % _noise.seed)

	_generation_active = true


func _on_player_hub_player_entered() -> void:
	_generation_active = false

	for chunk in _chunks.values():
		chunk.queue_free()

	_chunks.clear()
