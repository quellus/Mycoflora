extends Control

@onready var health_bar = %HealthBar
@onready var sword_level = %SwordLevel
@onready var toggleable_menu = $Toggleable
@onready var quest_list: Node = %QuestList
@onready var description_panel: DescriptionPanel = %DescriptionPanel
const QUEST_ENTRY = preload("res://scenes/quest_entry.tscn")
var is_menu_visible = false

func _ready() -> void:
	sword_level.text = "Sword level: 0"
	toggleable_menu.visible = false
	is_menu_visible = false
	
	generate_quest_entries()

func generate_quest_entries() -> void:
	var quests: Dictionary = QuestTracker.quests
	for quest_id in quests:
		var quest = quests[quest_id]
		if quest.state == QuestResource.QuestState.IN_PROGRESS:
			var quest_entry = QUEST_ENTRY.instantiate()
			quest_entry.update_quest(quest)
			quest_entry.focused.connect(description_panel.update_description)
			quest_list.add_child(quest_entry)

func toggle_menu():
	if is_menu_visible:
		toggleable_menu.visible = false
		get_tree().paused = false
		is_menu_visible = false
	elif get_tree().paused == false:
		var children = quest_list.get_children()
		for child in children:
			child.free()
		generate_quest_entries()
		if quest_list.get_child_count() > 0:
			var first_quest_entry = quest_list.get_children()[0]
			var button: Button = first_quest_entry.button
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
