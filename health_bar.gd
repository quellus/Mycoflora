class_name HealthBar extends Control

var hearts: Array[AnimatedSprite2D] = []

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
	for heart in get_children():
		if heart is AnimatedSprite2D:
			hearts.append(heart)
	update_visual()


func update_visual():
	for i in range(hearts.size()):
		var heart: AnimatedSprite2D = hearts[i]
		if i >= max_value:
			heart.visible = false
		elif i >= value:
			heart.visible = true
			if heart.animation != "empty":
				heart.play("empty")
		else:
			heart.visible = true
			if heart.animation != "full":
				heart.play("full")
