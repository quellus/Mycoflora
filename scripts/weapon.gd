extends Node2D

@onready var swing_timer: Timer = $SwingTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var area = $Area2D

const SWING_SPEED = 0.2
const ATTACK_SPEED = 0.3

var can_attack = true
	
func _ready():
	visible = false
	area.process_mode = Node.PROCESS_MODE_DISABLED
	
func attack():
	if can_attack:
		look_at(get_global_mouse_position())
		visible = true
		area.process_mode = Node.PROCESS_MODE_INHERIT
		swing_timer.start(SWING_SPEED)
		can_attack = false

func _on_swing_timer_timeout():
	print("swing timer timed out")
	visible = false
	area.process_mode = Node.PROCESS_MODE_DISABLED
	can_attack = false
	attack_timer.start(ATTACK_SPEED)

func _on_attack_timer_timeout():
	print("attack timer timed out")
	can_attack = true
