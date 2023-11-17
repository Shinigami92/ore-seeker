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
	tile_map.visible = false
