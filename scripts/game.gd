extends Control

signal exit_game()

const player_scene = preload("res://scenes/player.tscn")
const levels = {
	"world": preload("res://scenes/world.tscn"),
	"castle": preload("res://scenes/castle.tscn"),
}
var level:Level = null
var player:Player = null

func _ready():
	load_level("world", 0)
	AudioServer.set_bus_volume_db(0, linear_to_db(0.5))
	

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
	player.flower_count_changed.connect(_flower_count_changed)
	player.warp.connect(_warp, CONNECT_DEFERRED)
	player.dialog_trigger.connect(%DialogManager._on_dialogue_trigger)
	player.player_died.connect(_player_died)
	_player_health_changed(player.health)
	_flower_count_changed(player.flowers)


func _player_health_changed(health):
	%HealthBar.value = health


func _flower_count_changed(value):
	%FlowersLabel.text = "Flowers: " + str(value)


func _player_died():
	exit_game.emit()


func _warp(destination: String, spawn_point: int):
	load_level(destination, spawn_point)


func _volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
