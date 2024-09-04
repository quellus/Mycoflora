extends Control

signal load_game()

const game_scene = preload("res://scenes/game.tscn")


func _ready() -> void:
	$Label.text = "Version " + ProjectSettings.get_setting("application/config/version")
	$CenterContainer/VBoxContainer/PlayButton.grab_focus()


func _on_play_button_pressed():
	load_game.emit()
