class_name Chunk
extends Node2D

# TODO @Shinigami92 2023-11-13: read data dynamically
const CHUNK_SIZE = 16
const TILE_SIZE = 64

@onready var tile_map: TileMap = $TileMap
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready():
	visibility_notifier.screen_entered.connect(tile_map.show)
	visibility_notifier.screen_exited.connect(tile_map.hide)
	tile_map.visible = false

	# check if each tile does not collide with another tile
	for x in range(0, CHUNK_SIZE):
		for y in range(0, CHUNK_SIZE):
			var tile_coords: Vector2i = Vector2i(x, y)
			var tile: int = tile_map.get_cell_source_id(0, tile_coords)
			if tile == -1:
				continue
			var tile_pos: Vector2 = tile_map.global_position + (TILE_SIZE * Vector2(x, y))
			var tile_size: Vector2 = Vector2(TILE_SIZE, TILE_SIZE)
			var tile_rect: Rect2 = Rect2(tile_pos, tile_size)
			var tile_colliders = get_tree().get_nodes_in_group("collider")
			for collider in tile_colliders:
				var collider_tile_map: TileMap = collider

				for collider_tile in collider_tile_map.get_used_cells(0):
					var collider_tile_data: TileData = collider_tile_map.get_cell_tile_data(
						0, collider_tile
					)
					if not collider_tile_data.get_custom_data("wall"):
						continue
					var collider_tile_coords: Vector2i = collider_tile
					var collider_tile_pos: Vector2 = (
						collider_tile_map.global_position
						+ (TILE_SIZE * Vector2(collider_tile_coords.x, collider_tile_coords.y))
					)
					var collider_tile_size: Vector2 = Vector2(TILE_SIZE, TILE_SIZE)
					var collider_tile_rect: Rect2 = Rect2(collider_tile_pos, collider_tile_size)
					if collider_tile_rect.intersects(tile_rect):
						tile_map.erase_cell(0, tile_coords)
						break
