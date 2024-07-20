class_name Enemy extends CharacterBody2D

@onready var player = $"../Player"
const SPEED = 25

func _process(_delta):
	velocity = position.direction_to(player.global_position) * SPEED
	move_and_slide()
