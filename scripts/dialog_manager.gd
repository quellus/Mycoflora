class_name DialogueManager extends Control

@export var dialogue_trees: Dictionary = {}

@onready var dialogue_box: DialogueBox = %DialogueBox


func start(char_name: String):
	if char_name in dialogue_trees:
		var tree = dialogue_trees[char_name]
		_update_dialog_variables(tree)
		dialogue_box.data = tree
		dialogue_box.start("START")
	else:
		printerr("Dialogue requested but ", char_name, " not found in dialogue trees")

func _update_dialog_variables(data: DialogueData):
	print("updating variables")
	if "KILLED_BOSS" in data.variables:
		data.variables["KILLED_BOSS"]["value"] = SaveLoad.data["players"]["player1"]["killed_boss"]
