extends Control

const game_scene = preload("res://scenes/game.tscn")

func _ready() -> void:
	$Label.text = "Version " + ProjectSettings.get_setting("application/config/version")


func _on_play_button_pressed():
	get_tree().change_scene_to_packed(game_scene)
