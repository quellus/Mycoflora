class_name DialogueManager extends Control

@onready var dialogue_box = $DialogueBox

var dialogue_queue = []

func _on_dialogue_trigger(dialogues: Array[DialogResource]):
	var play_them = dialogue_queue.size() <= 0
	for dialogue in dialogues:
		dialogue_queue.append(dialogue)
	if play_them:
		play_next_dialogue()


func play_dialogue(dialogue: DialogResource):
	if dialogue.letter_time > 0:
		dialogue_box.play_dialogue(dialogue.name, dialogue.dialogue, dialogue.letter_time)
	else:
		dialogue_box.play_dialogue(dialogue.name, dialogue.dialogue)


func play_next_dialogue():
	if(dialogue_queue.size() > 0):
		var dialogue = dialogue_queue.pop_front()
		if dialogue.dialogue.length() > 0:
			play_dialogue(dialogue)


func _dialog_done() -> void:
	play_next_dialogue()
