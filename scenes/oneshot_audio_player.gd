extends AudioStreamPlayer

@export var audio_stream: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = audio_stream
	play()
	pitch_scale = 1 + randf_range(-0.1, 0.1)

func _on_finished() -> void:
	queue_free()
