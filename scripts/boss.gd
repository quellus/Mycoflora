class_name Boss extends CharacterBody2D

var health = 50
var target: Node2D = null
@export var speed_mod := 1
const SPEED = 10

@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var animtree: AnimationTree = $AnimationTree
@onready var state_machine = animtree["parameters/playback"]


func _process(_delta):
	if target != null:
		velocity = position.direction_to(target.global_position) * SPEED * speed_mod
		rotation = position.direction_to(target.global_position).angle()
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func take_damage(_position_from: Vector2):
	health -= 5
	if health <= 0:
		$AnimationPlayer2.play("death")
		animtree.set("parameters/conditions/attacking", false)
		state_machine.travel("default")
	else:
		$AnimationPlayer2.play("hurt")


func _on_vision_radius_body_entered(body):
	if body is Player:
		animtree.set("parameters/conditions/attacking", true)
		target = body


func _on_vision_radius_body_exited(body):
	if body == target:
		animtree.set("parameters/conditions/attacking", false)
		state_machine.travel("default")
		target = null


func _on_hurt_detector_area_entered(area):
	if area is HurtBox and !is_ancestor_of(area) and area.entity == "Player":
		area.hit()
		take_damage(area.global_position)


#func _on_attack_radius_body_entered(body: Node2D) -> void:
	#if body is Player and health > 0:
		#target = body
		#state_machine.travel("attack")


#func _on_hurt_box_body_entered(body: Node2D) -> void:
	#if body == target and animplayer.current_animation == "attack":
			#state_machine.travel("default")


func _on_animation_player_animation_changed(_old_name: StringName, new_name: StringName) -> void:
	print(new_name)
