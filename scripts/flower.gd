class_name Flower extends Interactable

const TOTAL_FLOWERS: int = 15
const FLOWER_COLUMNS: int = 3


func _ready():
	var column = 0
	var flower_index = randi_range(0, TOTAL_FLOWERS -1)
	if flower_index >= 5:
		flower_index -= 5
		column += 1
	if flower_index >= 5:
		flower_index -= 5
		column += 1
	sprite.texture.region.position.x = flower_index * 16
	sprite.texture.region.position.y = column * 16
