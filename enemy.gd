class_name Enemy extends CharacterBody2D

var health = 10
var knockback = false

@onready var player = $"../Player"
const SPEED = 25

func _process(delta):
	if !knockback:
		velocity = position.direction_to(player.global_position) * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20 * delta)
		velocity.y = move_toward(velocity.y, 0, 20 * delta)
		if velocity == Vector2.ZERO:
			knockback = false
	move_and_slide()

func take_damage():
	health -= 5
	velocity = position.direction_to(player.global_position) * SPEED * -1
	knockback = true
	if health <= 0:
		queue_free()


func _on_area_2d_body_entered(body):
	if body is Player:
		player.take_damage()
