extends MarginContainer

signal focused(long_description: String)

var quest_resource: QuestResource = null
@onready var label =  %Label
@onready var button: Button = %Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if quest_resource:
		label.text = quest_resource.quest_name

func update_quest(qr: QuestResource):
	quest_resource = qr


func _on_button_focus_entered() -> void:
	focused.emit(quest_resource.long_description)
