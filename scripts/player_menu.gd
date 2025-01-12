extends Control

@onready var health_bar = %HealthBar
@onready var sword_level = %SwordLevel
@onready var toggleable_menu = $Toggleable
var is_menu_visible = false

func _ready() -> void:
	sword_level.text = "Sword level: 0"
	toggleable_menu.visible = false
	is_menu_visible = false

func toggle_menu():
	if is_menu_visible:
		toggleable_menu.visible = false
		get_tree().paused = false
		is_menu_visible = false
	elif get_tree().paused == false:
		var button: Button = $"Toggleable/Quest Panel/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/MarginContainer/Button"
		button.grab_focus()
		toggleable_menu.visible = true
		get_tree().paused = true
		is_menu_visible = true


func _flower_count_changed(value):
	%FlowersLabel.text = "Florids: " + str(value)


func _sword_level_changed(value: int):
	sword_level.text = "Sword level: " + str(value)


func _player_health_changed(max_health, health):
	health_bar.max_value = max_health
	health_bar.value = health
