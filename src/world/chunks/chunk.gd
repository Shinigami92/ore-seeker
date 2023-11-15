class_name Chunk
extends Node2D

# TODO @Shinigami92 2023-11-13: read data dynamically
const CHUNK_SIZE = 16
const TILE_SIZE = 64

var tile_size: Vector2 = Vector2(TILE_SIZE, TILE_SIZE)

@onready var tile_map: TileMap = $TileMap
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready():
	visibility_notifier.screen_entered.connect(tile_map.show)
	visibility_notifier.screen_exited.connect(tile_map.hide)
	tile_map.visible = false

	var new_2d_region_rid: RID = NavigationServer2D.region_create()
	var default_2d_map_rid: RID = get_world_2d().get_navigation_map()
	NavigationServer2D.region_set_map(new_2d_region_rid, default_2d_map_rid)

	var new_navigation_polygon: NavigationPolygon = NavigationPolygon.new()
	var new_outline: PackedVector2Array = PackedVector2Array(
		[
			global_position,
			global_position + Vector2(1024.0, 0.0),
			global_position + Vector2(1024.0, 1024.0),
			global_position + Vector2(0.0, 1024.0),
		]
	)
	new_navigation_polygon.add_outline(new_outline)
	new_navigation_polygon.make_polygons_from_outlines()

	NavigationServer2D.region_set_navigation_polygon(new_2d_region_rid, new_navigation_polygon)

# 	var chunk_rect: Rect2 = Rect2(tile_map.global_position, tile_size * CHUNK_SIZE)

# 	# check if each tile does not collide with another tile
# 	var tile_map_colliders = get_tree().get_nodes_in_group("collider")

# 	for collider in tile_map_colliders:
# 		if not collider is TileMap:
# 			continue

# 		var collider_tile_map: TileMap = collider

# 		var collider_bounds = _calculate_bounds(collider_tile_map)

# 		if chunk_rect.intersects(collider_bounds):
# 			for x in range(0, CHUNK_SIZE):
# 				for y in range(0, CHUNK_SIZE):
# 					var tile_coords: Vector2i = Vector2i(x, y)
# 					var tile: int = tile_map.get_cell_source_id(0, tile_coords)

# 					if tile == -1:
# 						continue

# 					var tile_pos: Vector2 = tile_map.global_position + (TILE_SIZE * Vector2(x, y))
# 					var tile_rect: Rect2 = Rect2(tile_pos, tile_size)

# 					for collider_tile in collider_tile_map.get_used_cells(0):
# 						var collider_tile_data: TileData = collider_tile_map.get_cell_tile_data(
# 							0, collider_tile
# 						)

# 						if not collider_tile_data.get_custom_data("wall"):
# 							continue
# 						var collider_tile_coords: Vector2i = collider_tile
# 						var collider_tile_pos: Vector2 = (
# 							collider_tile_map.global_position
# 							+ (TILE_SIZE * Vector2(collider_tile_coords.x, collider_tile_coords.y))
# 						)
# 						var collider_tile_rect: Rect2 = Rect2(collider_tile_pos, tile_size)

# 						if collider_tile_rect.intersects(tile_rect):
# 							tile_map.erase_cell(0, tile_coords)
# 							break

# func _calculate_bounds(tilemap: TileMap) -> Rect2:
# 	var used_cells: Array[Vector2i] = tilemap.get_used_cells(0)

# 	var min_x: float = used_cells[0].x
# 	var max_x: float = used_cells[0].x
# 	var min_y: float = used_cells[0].y
# 	var max_y: float = used_cells[0].y

# 	for pos in used_cells:
# 		if pos.x < min_x:
# 			min_x = pos.x
# 		elif pos.x > max_x:
# 			max_x = pos.x

# 		if pos.y < min_y:
# 			min_y = pos.y
# 		elif pos.y > max_y:
# 			max_y = pos.y

# 	return Rect2(
# 		Vector2(min_x, min_y) * TILE_SIZE, Vector2(max_x - min_x + 1, max_y - min_y + 1) * TILE_SIZE
# 	)
