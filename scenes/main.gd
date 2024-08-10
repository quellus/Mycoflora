extends Control

const main_menu_scene = preload("res://scenes/main_menu.tscn")
const game_scene = preload("res://scenes/game.tscn")

var current_scene: Node = null

func _ready() -> void:
	_load_main_menu()


func clear_old_scene() -> void:
	if current_scene != null:
		current_scene.queue_free()
		current_scene = null


func _load_game() -> void:
	clear_old_scene()
	var new_scene = game_scene.instantiate()
	add_child(new_scene)
	new_scene.exit_game.connect(_load_main_menu)
	current_scene = new_scene


func _load_main_menu() -> void:
	clear_old_scene()
	var new_scene = main_menu_scene.instantiate()
	add_child(new_scene)
	new_scene.load_game.connect(_load_game)
	current_scene = new_scene
