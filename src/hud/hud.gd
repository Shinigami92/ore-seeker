class_name Hud
extends Camera2D

@export var player: Player

@onready var player_carried_dirithium_label: Label = $PlayerCarriedDirithium
@onready var player_corrdinates_label: Label = $PlayerCoordinates


func _ready() -> void:
	player.carried_dirithium_changed.connect(_redraw_player_carried_dirithium_label)


func _process(_delta: float) -> void:
	var player_position: Vector2i = player.position * Vector2(1, -1) / Chunk.TILE_SIZE
	player_corrdinates_label.text = "%s" % [player_position]


func _redraw_player_carried_dirithium_label(carried_dirithium: int) -> void:
	player_carried_dirithium_label.text = "Carried Dirithium: %d" % carried_dirithium
