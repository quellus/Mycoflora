extends Node2D

@onready var swing_timer: Timer = $SwingTimer
@onready var hurt_box: HurtBox = $HurtBox
@onready var collision_shape = $HurtBox/CollisionPolygon2D

var fireball_scene: PackedScene = preload("res://scenes/fireball.tscn")

const SWING_SPEED = 0.2
const ATTACK_SPEED = 0.3

var magic_mode = true
var can_attack = true

func _ready():
	hurt_box.visible = false
	collision_shape.disabled = true
	
func attack(controller: bool):
	if can_attack:
		var direction: Vector2
		if controller:
			direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
			rotation = direction.angle()
		if !controller:
			direction = global_position.direction_to(get_global_mouse_position())
			rotation = direction.angle()
		if magic_mode and $"..".flowers > 0:
			var fireball: Projectile = fireball_scene.instantiate()
			fireball.movement_direction = direction
			fireball.movement_speed = 200
			fireball.damage = 5
			get_tree().root.add_child(fireball)
			fireball.global_position = $HurtBox.global_position
			$"..".flowers -= 1
		else:
			hurt_box.visible = true
			collision_shape.disabled = false
		swing_timer.start(SWING_SPEED)
		can_attack = false

func _on_swing_timer_timeout():
	hurt_box.visible = false
	collision_shape.disabled = true
	can_attack = true
