class_name PlayerHealth
extends Control

@export var player: Player

@onready var heart_1: TextureRect = $Forground/Heart1
@onready var heart_2: TextureRect = $Forground/Heart2
@onready var heart_3: TextureRect = $Forground/Heart3


func _process(_delta: float) -> void:
	# TODO @Shinigami92 2023-11-20: This is highly unoptimized
	# instead of using _process, player's health_changed signal should be used
	heart_1.visible = player.health >= 1
	heart_2.visible = player.health >= 2
	heart_3.visible = player.health >= 3
