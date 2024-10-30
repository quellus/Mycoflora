class_name Enemy extends CharacterBody2D

signal target_state_changed(bool)

@onready var nav_agent = $NavigationAgent2D

var health = 2
var target: Player = null:
	set(value):
		if value != target:
			target = value
			if target == null:
				target_state_changed.emit(false)
			else:
				target_state_changed.emit(true)

var is_in_range: bool = false
@onready var sprite = $AnimatedSprite2D
@export var speed_mod := 1
const SPEED = 70

@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var animtree: AnimationTree = $AnimationTree
@onready var state_machine = animtree["parameters/playback"]

func _ready() -> void:
	add_to_group("enemy")


func _physics_process(_delta):
	var next_pos: Vector2 = nav_agent.get_next_path_position()
	if target != null:
		if (target.global_position.distance_to(nav_agent.target_position) >= 30 or nav_agent.is_navigation_finished()):
			nav_agent.target_position = target.global_position
			next_pos = nav_agent.get_next_path_position()
		velocity = global_position.direction_to(next_pos) * SPEED * speed_mod
	elif !nav_agent.is_navigation_finished():
		velocity = global_position.direction_to(next_pos) * SPEED * speed_mod
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func take_damage(position_from: Vector2, damage: int):
	health -= damage
	velocity = position.direction_to(position_from) * SPEED * -4
	if health <= 0:
		target = null
		state_machine.travel("death")
	else:
		state_machine.travel("knockback")


func _on_vision_radius_body_entered(body):
	if body is Player:
		target = body
		nav_agent.target_position = body.global_position


func _on_vision_radius_body_exited(body):
	if body == target:
		target = null


func _on_hurt_detector_area_entered(area):
	if area is HurtBox and !is_ancestor_of(area) and area.entity == "Player":
		area.hit()
		take_damage(area.global_position, area.damage)


func _on_attack_radius_body_entered(body: Node2D) -> void:
	if body is Player and health > 0:
		is_in_range = true
		target = body
		state_machine.travel("attack")
		$Timer.start(5)


func _on_attack_radius_body_exited(body: Node2D) -> void:
	if body is Player:
		is_in_range = false


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body == target and animplayer.current_animation == "attack":
			state_machine.travel("default")


func _on_attack_timer_timeout() -> void:
	if target and is_in_range:
		state_machine.travel("attack")
	else:
		$Timer.stop()
