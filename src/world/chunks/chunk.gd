class_name Chunk
extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var visibility_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	visibility_notifier.screen_entered.connect(tile_map.show)
	visibility_notifier.screen_exited.connect(tile_map.hide)
	tile_map.visible = false
