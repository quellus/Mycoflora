extends Node2D

@onready var swing_timer: Timer = $SwingTimer
@onready var collision_shape = $HurtBox/CollisionPolygon2D

const SWING_SPEED = 0.2
const ATTACK_SPEED = 0.3

var can_attack = true
	
func _ready():
	print_debug("test")
	visible = false
	collision_shape.disabled = true
	
func attack():
	if can_attack:
		look_at(get_global_mouse_position())
		visible = true
		collision_shape.disabled = false
		swing_timer.start(SWING_SPEED)
		can_attack = false

func _on_swing_timer_timeout():
	visible = false
	collision_shape.disabled = true
	can_attack = true
