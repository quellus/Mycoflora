class_name Projectile extends CharacterBody2D

var movement_direction: Vector2 = Vector2.UP
var movement_speed: float = 200
var damage = 5


func _ready():
	$HurtBox.damage = damage


func _physics_process(delta):
	velocity = movement_direction * movement_speed
	move_and_collide(velocity * delta)
