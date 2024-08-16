class_name Projectile extends CharacterBody2D

const FIREBALL_SCENE = preload("res://scenes/fireball.tscn")

var movement_direction: Vector2
var movement_speed: float = 100

static func new_projectile(new_movement_direction: Vector2, new_movement_speed: float, damage: float) -> Projectile:
	var fireball_instance = FIREBALL_SCENE.instantiate()
	fireball_instance.movement_speed = new_movement_speed
	fireball_instance.movement_direction = new_movement_direction
	#fireball_instance.hurt_box.damage = damage
	return fireball_instance

func _physics_process(delta):
	velocity = movement_direction * movement_speed
	move_and_slide()
