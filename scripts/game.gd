extends Control

signal exit_game()

const player_scene = preload("res://scenes/player.tscn")
const levels = {
	"world": preload("res://scenes/world.tscn"),
	"castle": preload("res://scenes/castle.tscn"),
}
var level:Level = null
var player:Player = null
var enemies_targeting_player: int = 0
const PLAYER_HEAL_TIMEOUT: int = 3
@onready var player_heal_timer: Timer = %PlayerHealTimer
@onready var health_bar: HealthBar = %HealthBar

func _ready():
	load_level("world", 0)
	AudioServer.set_bus_volume_db(0, linear_to_db(0.5))
	
	%SwordLevel.text = "Sword level: 0"
	

func load_level(level_name: String, spawn_index: int):
	if level_name in levels:
		if level != null:
			level.queue_free()
		level = levels[level_name].instantiate()
		add_child(level)
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy: Enemy in enemies:
			enemy.target_state_changed.connect(_on_enemy_target_state_changed)
		var bosses = get_tree().get_nodes_in_group("boss")
		for boss: Boss in bosses:
			boss.target_state_changed.connect(_on_enemy_target_state_changed)
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
	player.dialog_trigger.connect(_on_dialogue_trigger)
	player.player_died.connect(_player_died)
	player.sword_level_changed.connect(_sword_level_changed)
	_player_health_changed(player.max_health, player.health)
	_flower_count_changed(player.flowers)


func _player_health_changed(max_health, health):
	health_bar.max_value = max_health
	health_bar.value = health


func _flower_count_changed(value):
	%FlowersLabel.text = "Florids: " + str(value)


func _sword_level_changed(value: int):
	%SwordLevel.text = "Sword level: " + str(value)

func _player_died():
	exit_game.emit()


func _warp(destination: String, spawn_point: int):
	load_level(destination, spawn_point)


func _volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _dialog_complete():
	if player:
		player.in_dialog = false

func _on_dialogue_trigger(char_name: String):
	%DialogueManager.start(char_name)

func _on_enemy_target_state_changed(state: bool):
	if state:
		enemies_targeting_player += 1
		player_heal_timer.stop()
	else:
		enemies_targeting_player -= 1
		if enemies_targeting_player <= 0:
			player_heal_timer.start(PLAYER_HEAL_TIMEOUT)


func _on_player_heal_timer_timeout() -> void:
	if enemies_targeting_player <= 0:
		player.heal()
