class_name Enemy extends CharacterBody2D

var health = 10
var knockback = false
var target: Node2D = null
@onready var sprite = $Sprite2D2

const SPEED = 25

func _process(delta):
	if target != null:
		if !knockback:
			velocity = position.direction_to(target.global_position) * SPEED
		else:
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
	knockback = true
	if health <= 0:
		queue_free()


func _on_vision_radius_body_entered(body):
	if body is Player:
		target = body


func _on_vision_radius_body_exited(body):
	if body == target:
		target = null


func _on_hurt_detector_area_entered(area):
	if area is HurtBox and !is_ancestor_of(area) and area.entity == "Player":
		take_damage(area.position)


func _on_knockback_timer_timeout():
	sprite.modulate = Color(1,1,1)
	knockback = false
