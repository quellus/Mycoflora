class_name Flower extends Interactable

const TOTAL_FLOWERS: int = 15
const FLOWER_COLUMNS: int = 3
const ONESHOT_AUDIO_PLAYER = preload("res://scenes/oneshot_audio_player.tscn")
const IENBA__GAME_PICK_UP_2 = preload("res://assets/sounds/ienba__game-pick-up2.wav")

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


func interact():
	var audio_player = ONESHOT_AUDIO_PLAYER.instantiate()
	audio_player.audio_stream = IENBA__GAME_PICK_UP_2
	get_tree().root.add_child(audio_player)
	queue_free()
