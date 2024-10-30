class_name Interactable extends Area2D

signal interacted

@export var sprite: Sprite2D 
@export var resource: Resource

enum ItemTypes {
	SWORD,
	HEALTH
}

#var flowers
#var weapon_level
#var dialogue_name

func highlight(value: bool):
	if value:
		sprite.modulate = Color(1.5,1.5,1.5)
	else:
		sprite.modulate = Color(1,1,1)

func interact():
	interacted.emit()
