class_name PlayerOreDeliveryDetector
extends Area2D

var stored_dirithium_amount: int = 0

@onready var label: Label = $Label


func _on_body_entered(body: Node):
	if body is Player:
		stored_dirithium_amount += body.carried_dirithium
		body.carried_dirithium = 0
		body.carried_dirithium_changed.emit(body.carried_dirithium)
		label.text = "%d Dirithium" % stored_dirithium_amount
