class_name DialogueManager extends Control

@export var dialogue_trees: Dictionary = {}

@onready var dialogue_box: DialogueBox = %DialogueBox


func start(char_name: String):
	if char_name in dialogue_trees:
		dialogue_box.data = dialogue_trees[char_name]
		dialogue_box.start("START")
	else:
		printerr("Dialogue requested but ", char_name, " not found in dialogue trees")
