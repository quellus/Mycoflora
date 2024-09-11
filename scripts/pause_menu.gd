extends Control

var current_menu: String

@onready var menus = {
	"main_pause": %MainPauseMenu,
	"settings": %SettingsMenu
}


func _ready() -> void:
	hide_menus()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start"):
		if current_menu == "":
			show_menu("main_pause")
		else:
			hide_menus()
	elif event.is_action_pressed("ui_cancel"):
		if current_menu == "main_pause":
			hide_menus()
		elif current_menu != "":
			show_menu("main_pause")


func hide_menus() -> void:
	get_tree().paused = false
	for menu in menus.values():
		menu.visible = false
	current_menu = ""


func show_menu(menu_name: String) -> void:
	get_tree().paused = true
	for menu in menus.values():
		menu.visible = false
	menus[menu_name].visible = true
	menus[menu_name].first_button.grab_focus()
	current_menu = menu_name


func _on_settings_button_pressed() -> void:
	show_menu("settings")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_back_button_pressed() -> void:
	show_menu("main_pause")
