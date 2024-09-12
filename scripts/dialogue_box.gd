class_name DialogueBox extends Control

signal dialog_done

@onready var label: RichTextLabel = $RichTextLabel
@onready var lettertimer: Timer = $LetterTimer
@onready var pause_timer: Timer = $PauseTimer

var lettertime: float = 0
var string: String = ""
var total_length: int = 0

func _ready():
	label.visible = false
	_redraw_label()


func play_dialogue(speaker: String, dialogue: String, letter_time := 0.05):
	label.text = "[u]" + speaker + "[/u]\n"
	string = dialogue
	total_length = dialogue.length()
	label.visible = letter_time
	lettertime = letter_time
	_newletter()


func _newletter():
	if string.length() > 0:
		label.text = label.text+string[0]
		string = string.erase(0)
		lettertimer.start(lettertime)
	else:
		lettertimer.stop()
		#pause_timer.start(float(total_length) / float(100))
		dialog_done.emit()


func _redraw_label():
	label.size.y = label.get_content_height()
	label.set_position(Vector2(size.x/2-(label.size.x-6)/2, size.y-label.size.y-6))

func dialog_complete():
	label.visible = false

func _pause_timeout() -> void:
	label.visible = false
	pause_timer.stop()
	dialog_done.emit()
