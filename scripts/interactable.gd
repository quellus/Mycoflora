class_name Interactable extends Area2D

enum Type {
	FLOWER,
	WEAPON
}

@export var type: Type
@export var sprite: Sprite2D

func highlight(value: bool):
	if value:
		sprite.modulate = Color(1.5,1.5,1.5)
	else:
		sprite.modulate = Color(1,1,1)

func interact():
	queue_free()
