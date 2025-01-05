extends AudioStreamPlayer

@export var audio_stream: Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if audio_stream.size() > 0:
		stream = audio_stream.pick_random()
	play()
	pitch_scale += randf_range(-0.2, 0.2)

func _on_finished() -> void:
	queue_free()
