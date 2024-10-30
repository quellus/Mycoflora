class_name HealthBar extends Control

const HEART_TEXTURE = preload("res://assets/Heart.png")
const HEART_EMPTY_TEXTURE = preload("res://assets/HeartEmpty.png")

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
	update_visual()


func update_visual():
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
	$HBoxContainer.add_child(texture_rect)
