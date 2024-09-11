class_name Interactable extends Area2D

signal interacted

@export var sprite: Sprite2D

func highlight(value: bool):
	if value:
		sprite.modulate = Color(1.5,1.5,1.5)
	else:
		sprite.modulate = Color(1,1,1)

func interact():
	interacted.emit()
