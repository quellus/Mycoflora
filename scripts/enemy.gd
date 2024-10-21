class_name Enemy extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D

@export var hop = false

@export_group("animation")
@export var speed_mod: float = 1

var health = 10
var target: Player = null
var attack_direction: Vector2 = Vector2.ZERO
var is_in_range: bool = false
const SPEED = 70
@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var animtree: AnimationTree = $AnimationTree
@onready var state_machine = animtree["parameters/playback"]

const FROGGY_ANIM_TREE = preload("res://resources/froggy_anim_tree.tres")
const MUSHOOM_ANIM_TREE = preload("res://resources/mushoom_anim_tree.tres")

func _ready():
	animtree.tree_root = FROGGY_ANIM_TREE

func _physics_process(_delta):
	var next_pos: Vector2 = nav_agent.get_next_path_position()
	if target != null:
		if animplayer.current_animation == "attack":
			if attack_direction == Vector2.ZERO:
				attack_direction = global_position.direction_to(next_pos)
			velocity = attack_direction * SPEED * speed_mod
		else:
			if (target.global_position.distance_to(nav_agent.target_position) >= 30 or nav_agent.is_navigation_finished()):
				nav_agent.target_position = target.global_position
				next_pos = nav_agent.get_next_path_position()
			velocity = global_position.direction_to(next_pos) * SPEED * speed_mod
	elif !nav_agent.is_navigation_finished():
		velocity = global_position.direction_to(next_pos) * SPEED * speed_mod
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func take_damage(position_from: Vector2):
	health -= 5
	velocity = position.direction_to(position_from) * SPEED * -4
	if health <= 0:
		state_machine.travel("death")
	else:
		state_machine.travel("knockback")


func _on_vision_radius_body_entered(body):
	if body is Player:
		if hop:
			state_machine.travel("attack")
			
		target = body
		nav_agent.target_position = body.global_position


func _on_vision_radius_body_exited(body):
	if body == target:
		target = null


func _on_hurt_detector_area_entered(area):
	if area is HurtBox and !is_ancestor_of(area) and area.entity == "Player":
		area.hit()
		take_damage(area.global_position)


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
		if hop:
			state_machine.travel("default")
		else:
			state_machine.travel("walk")


func _on_attack_timer_timeout() -> void:
	if target and is_in_range:
		state_machine.travel("attack")
	else:
		$Timer.stop()


func _on_animation_player_animation_changed(old_name: StringName, new_name: StringName) -> void:
	print(new_name)
	if old_name == "attack" and new_name != "attack":
		attack_direction = Vector2.ZERO


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	print(anim_name)
	pass # Replace with function body.
