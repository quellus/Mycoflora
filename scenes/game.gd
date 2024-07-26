extends Control

var player_scene = preload("res://Scenes/player.tscn")
var levels = {
	"level1": preload("res://scenes/level1.tscn")
}
var level:Level
var player:Player

func _ready():
	load_level("level1", 0)

func load_level(level_name: String, spawn_index: int):
	if level_name in levels:
		if level != null:
			level.queue_free()
		level = levels[level_name].instantiate()
		add_child(level)
		_spawn_player(level.spawn_points[spawn_index].global_position)

func _spawn_player(spawn_position: Vector2):
	if player != null:
		player.queue_free()
	player = player_scene.instantiate() as Player
	add_child(player)
	player.global_position = spawn_position
	player.health_changed.connect(_player_health_changed)
	_player_health_changed(player.health)
		

func _player_health_changed(health):
	%HealthBar.value = health
