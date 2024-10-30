class_name HealthBar extends Control

const HEART_TEXTURE = preload("res://assets/Heart.png")
const HEART_EMPTY_TEXTURE = preload("res://assets/HeartEmpty.png")

var hearts: Array[TextureRect] = []

var value: int = 10:
	set(val):
		if value != val:
			value = val
			update_visual()
		
var max_value: int = 10:
	set(val):
		if max_value != val:
			max_value = val
			update_visual()

func _ready() -> void:
	initialize_hearts()


func update_visual():
	if hearts.size() > max_value:
		initialize_hearts()
		return
	elif hearts.size() < max_value:
		for i in range(max_value - hearts.size()):
			create_heart(i - 1 + max_value)
	for i in range(hearts.size()):
		if i >= value:
			hearts[i].texture = HEART_EMPTY_TEXTURE
		else:
			hearts[i].texture = HEART_TEXTURE


func initialize_hearts():
	for child in $HBoxContainer.get_children():
		child.queue_free()
	for i in range(max_value):
		create_heart(i)


func create_heart(index: int):
	var texture_rect = TextureRect.new()
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
	
	if index >= value:
		texture_rect.texture = HEART_EMPTY_TEXTURE
	else:
		texture_rect.texture = HEART_TEXTURE
	hearts.append(texture_rect)
	$HBoxContainer.add_child(texture_rect)
