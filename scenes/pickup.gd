class_name Pickup extends Area2D


func _on_interactable_interacted() -> void:
	queue_free()
