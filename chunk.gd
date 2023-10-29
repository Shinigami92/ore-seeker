class_name Chunk
extends TileMap


func _ready():
	# set ground
	for x in 16:
		for y in 16:
			set_cell(0, Vector2i(x, y), 0, Vector2i(6, 2), 0)
