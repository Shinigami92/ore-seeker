class_name Hud
extends Camera2D

@export var player: Player

@onready var player_carried_dirithium_label: Label = $PlayerCarriedDirithium


func _ready():
	player.carried_dirithium_changed.connect(_redraw_player_carried_dirithium_label)


func _redraw_player_carried_dirithium_label(carried_dirithium: int):
	player_carried_dirithium_label.text = "Carried Dirithium: %d" % carried_dirithium
