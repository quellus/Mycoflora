class_name Pickup extends CharacterBody2D

func _on_interactable_interacted() -> void:
	queue_free()
