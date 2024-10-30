class_name HurtBox extends Area2D

signal hit_success

@export var damage: float
@export var entity: String

func hit():
	hit_success.emit()
