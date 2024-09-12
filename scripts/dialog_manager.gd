class_name DialogueManager extends Control

signal dialog_complete

@onready var dialogue_box = $DialogueBox

var waiting_for_input: bool = false
var dialogue_queue = []

func _input(event: InputEvent) -> void:
	if waiting_for_input and event.is_action_pressed("interact"):
		print("play next dialog")
		waiting_for_input = false
		play_next_dialogue()


func _on_dialogue_trigger(dialogues: Array[DialogResource]):
	print("dialog trigger")
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
	else:
		dialogue_box.dialog_complete()
		waiting_for_input = false
		dialog_complete.emit()


func _dialog_done() -> void:
	waiting_for_input = true
