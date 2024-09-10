extends Node2D

func _on_interactable_interacted() -> void:
	queue_free()
