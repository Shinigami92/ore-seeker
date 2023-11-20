class_name PlayerHealth
extends Control

# TODO @Shinigami92 2023-11-20: find a way to make this dynamically and not just for 3 hearts

@onready var heart_1: TextureRect = $Forground/Heart1
@onready var heart_2: TextureRect = $Forground/Heart2
@onready var heart_3: TextureRect = $Forground/Heart3


func _on_player_health_changed(_player: Player, _old_value: int, new_value: int) -> void:
	heart_3.visible = new_value >= 3
	heart_2.visible = new_value >= 2
