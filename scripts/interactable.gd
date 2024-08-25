class_name Interactable extends Area2D

const TOTAL_FLOWERS: int = 15
const FLOWER_COLUMNS: int = 3
@onready var flower_sprite: Sprite2D = $Sprite2D

func _ready():
	var column = 0
	var flower_index = randi_range(0, TOTAL_FLOWERS -1)
	print(flower_index)
	if flower_index > 5:
		flower_index -= 5
		column += 1
	if flower_index > 5:
		flower_index -= 5
		column += 1
	flower_sprite.texture.region.position.x = flower_index * 16
	flower_sprite.texture.region.position.y = column * 16

func highlight(value: bool):
	if value:
		flower_sprite.modulate = Color(1.5,1.5,1.5)
	else:
		flower_sprite.modulate = Color(1,1,1)

func interact():
	queue_free()
