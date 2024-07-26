class_name Enemy extends CharacterBody2D

var health = 10
var knockback = false
var target: Node2D = null
@onready var sprite = $AnimatedSprite2D
@export var speed_mod := 1
const SPEED = 25
@onready var animation_player = $AnimationPlayer

@onready var animtree: AnimationTree = $AnimationTree
@onready var state_machine = animtree["parameters/playback"]

func _process(delta):
	if health > 0:
		if target != null:
			if !knockback:
				velocity = position.direction_to(target.global_position) * SPEED * speed_mod
			elif knockback:
				velocity.x = move_toward(velocity.x, 0, 20 * delta)
				velocity.y = move_toward(velocity.y, 0, 20 * delta)
				if velocity == Vector2.ZERO:
					knockback = false
		move_and_slide()

func take_damage(position_from: Vector2):
	health -= 5
	velocity = position.direction_to(position_from) * SPEED * -4
	$KnockbackTimer.start(0.1)
	sprite.modulate = Color(100,100,100)
	state_machine.travel("default")
	knockback = true
	if health <= 0:
		state_machine.travel("death")
		var timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(_death_timer_timeout)
		timer.start(1)


func _on_vision_radius_body_entered(body):
	if body is Player:
		target = body


func _on_vision_radius_body_exited(body):
	if body == target:
		target = null


func _on_hurt_detector_area_entered(area):
	if area is HurtBox and !is_ancestor_of(area) and area.entity == "Player":
		take_damage(area.global_position)


func _on_knockback_timer_timeout():
	sprite.modulate = Color(1,1,1)
	knockback = false

func _death_timer_timeout():
	queue_free()


func _on_attack_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		state_machine.travel("attack")


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body == target:
		if animation_player.is_playing() and animation_player.current_animation == "attack":
			state_machine.travel("default")
