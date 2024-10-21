class_name DialogueManager extends Control

@export var dialogue_trees: Dictionary = {}

@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var nine_patch: NinePatchRect = %NinePatchRect
@onready var audio_player: AudioStreamPlayer = %DialogueAudioPlayer

var current_dialogue: String = ""
var silent_characters: String = ",.?/ -_!@#$%^&*()~`"

func _ready() -> void:
	dialogue_box.visible = false
	nine_patch.visible = false
	dialogue_box.custom_effects[0].char_displayed.connect(_on_char_displayed)
	dialogue_box.dialogue_processed.connect(_on_dialogue_processed)

func start(char_name: String):
	if char_name in dialogue_trees:
		var tree = dialogue_trees[char_name]
		_update_dialog_variables(tree)
		dialogue_box.data = tree
		dialogue_box.start("START")
	else:
		printerr("Dialogue requested but ", char_name, " not found in dialogue trees")

func _update_dialog_variables(data: DialogueData):
	if "KILLED_BOSS" in data.variables:
		data.variables["KILLED_BOSS"]["value"] = SaveLoad.data["players"]["player1"]["killed_boss"]

func _on_char_displayed(char_index: int):
	if char_index % 2 == 0:
		if !current_dialogue[char_index] in silent_characters:
			audio_player.pitch_scale = 2 + randf_range(-0.1, 0.1)
			audio_player.play()

func _on_dialogue_processed(_speaker : Variant, dialogue : String, _options : Array[String]):
	current_dialogue = dialogue


func _on_dialogue_box_dialogue_started(_id: String) -> void:
	nine_patch.visible = true


func _on_dialogue_box_dialogue_ended() -> void:
	nine_patch.visible = false
