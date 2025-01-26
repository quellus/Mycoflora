class_name QuestResource extends Resource

enum QuestState {
	NOT_STARTED,
	IN_PROGRESS,
	COMPLETE
}

@export var state: QuestState = QuestState.NOT_STARTED
@export var id: String = ""
@export var quest_name: String = ""
@export var long_description: String = ""
