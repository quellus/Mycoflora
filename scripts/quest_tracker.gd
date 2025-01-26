extends Node

#var quests: Array[QuestResource] = []
var quests: Dictionary = {}

const QUESTS_DIRECTORY = "res://resources/quests"

func _ready() -> void:
	fetch_rooms()

func fetch_rooms():
	var all_quests: Array[QuestResource] = []
	for file in DirAccess.get_files_at(QUESTS_DIRECTORY):
		if file.ends_with(".remap"):
			file = file.left(-6)
		var quest = _load_quest(QUESTS_DIRECTORY+"/"+file)
		all_quests.append(quest)
		quests[quest.id] = quest

func dialogue_signal(value):
	print("Quest tracker received dialogue signal", value)
	match value:
		"investigate_forest_quest_start":
			if quests["investigate_forest"].state == QuestResource.QuestState.NOT_STARTED:
				quests["investigate_forest"].state = QuestResource.QuestState.IN_PROGRESS

func _load_quest(path: String) -> QuestResource:
	var loaded = null
	if ResourceLoader.exists(path) :
		loaded = ResourceLoader.load(path)
	if loaded is QuestResource:
		return loaded
	return null
