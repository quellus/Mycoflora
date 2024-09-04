extends Control

signal load_game()

const game_scene = preload("res://scenes/game.tscn")

@onready var main_menu = $Menus/MainMenu
@onready var attribution_menu = $Menus/AttributionMenu

func _ready() -> void:
	$VersionLabel.text = "Version " + ProjectSettings.get_setting("application/config/version")
	_show_main_menu()


func _on_play_button_pressed():
	load_game.emit()


func _on_quit_button_pressed():
	get_tree().quit()


func _show_main_menu():
	main_menu.visible = true
	attribution_menu.visible = false
	%PlayButton.grab_focus()


func _show_attribution():
	main_menu.visible = false
	attribution_menu.visible = true
	%AttrBackButton.grab_focus()
