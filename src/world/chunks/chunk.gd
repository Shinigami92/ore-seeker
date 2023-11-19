class_name Chunk
extends Node2D

const CHUNK_SIZE = 16
const TILE_SIZE = 64
const CHUNK_WIDTH = CHUNK_SIZE * TILE_SIZE

var _coordinated: Vector2i
var _random: RandomNumberGenerator = RandomNumberGenerator.new()

var _player_hub: PlayerHub

@onready var tile_map: TileMap = $TileMap
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


static func instantiate(coordinated: Vector2i, noise: Noise, player_hub: PlayerHub) -> Chunk:
	var chunk: Chunk = preload("chunk.tscn").instantiate()

	chunk._coordinated = coordinated
	chunk._player_hub = player_hub

	var noise_value: float = noise.get_noise_2dv(coordinated)
	chunk._random.seed = int(remap(noise_value, -1.0, 1.0, 0, 2 ** 32 - 1))

	return chunk


func _ready() -> void:
	visibility_notifier.screen_entered.connect(tile_map.show)
	visibility_notifier.screen_exited.connect(tile_map.hide)

	position = _coordinated * CHUNK_WIDTH

	# Stones
	for i in range(4):
		var atlas_coords: Vector2i = Vector2i(_random.randi_range(0, 7), _random.randi_range(0, 2))
		_place_random_cell(atlas_coords, 0)

	# Grass
	for i in range(6):
		var atlas_coords: Vector2i = Vector2i(_random.randi_range(0, 14), _random.randi_range(0, 5))
		_place_random_cell(atlas_coords, 1)

	# Flowers
	for i in range(2):
		var atlas_coords: Vector2i = Vector2i(_random.randi_range(0, 5), 6)
		_place_random_cell(atlas_coords, 1)

	var ore_probability: float = (
		0.0 if _coordinated.length_squared() <= 4 else _random.randf_range(0.0, 1.0)
	)

	if ore_probability > 0.8:
		var ore: Ore = Ore.instantiate(_player_hub)
		var x: int = _random.randi_range(0, CHUNK_SIZE - 1)
		var y: int = _random.randi_range(0, CHUNK_SIZE - 1)
		ore.position = Vector2i(x, y) * TILE_SIZE
		add_child(ore)

	tile_map.visible = false


func _place_random_cell(atlas_coords: Vector2i, source_id: int) -> void:
	var x: int = _random.randi_range(0, CHUNK_SIZE - 1)
	var y: int = _random.randi_range(0, CHUNK_SIZE - 1)
	var coords: Vector2i = Vector2i(x, y)
	tile_map.set_cell(0, coords, source_id, atlas_coords, 0)
