class_name DialogueManager extends Control

signal dialog_complete

@onready var dialogue_box = $DialogueBox

var character_dialogs: Dictionary = {
	"The Old Angy Guy The Real": preload("res://resources/dialogs/AngyGuy.tres"),
	"Vaelvia": preload("res://resources/dialogs/Vaelvia.tres"),
	"Princess McBeauty": preload("res://resources/dialogs/PrincessMcBeauty.tres")
}

var waiting_for_input: bool = false
var dialogue_queue: Array[DialogQueueItem] = []

func _input(event: InputEvent) -> void:
	if waiting_for_input and event.is_action_pressed("interact"):
		print("play next dialog")
		waiting_for_input = false
		play_next_dialogue()


func _on_dialogue_trigger(char_name: String):
	print("dialog trigger")
	var play_them: bool = dialogue_queue.size() <= 0
	var dialogues: CharacterDialogs = character_dialogs[char_name]
	for dialogue: DialogResource in dialogues.dialogs["ANGYGUY_GREET"]:
		var queue_item = DialogQueueItem.new()
		queue_item.name = char_name
		queue_item.dialogue = tr(dialogue.dialogue)
		queue_item.letter_time = dialogue.letter_time
		dialogue_queue.append(queue_item)
	if play_them:
		play_next_dialogue()


func play_dialogue(dialogue: DialogQueueItem):
	if dialogue.letter_time > 0:
		dialogue_box.play_dialogue(dialogue.name, dialogue.dialogue, dialogue.letter_time)
	else:
		dialogue_box.play_dialogue(dialogue.name, dialogue.dialogue)


func play_next_dialogue():
	if(dialogue_queue.size() > 0):
		var dialogue = dialogue_queue.pop_front()
		if dialogue.dialogue.length() > 0:
			play_dialogue(dialogue)
	else:
		dialogue_box.dialog_complete()
		waiting_for_input = false
		dialog_complete.emit()


func _dialog_done() -> void:
	waiting_for_input = true
