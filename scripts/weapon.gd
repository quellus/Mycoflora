extends Node2D

@onready var swing_timer: Timer = $SwingTimer
@onready var hurt_box: HurtBox = $HurtBox
@onready var collision_shape = $HurtBox/CollisionPolygon2D

const fireball_scene: PackedScene = preload("res://scenes/fireball.tscn")
const fireball_sound: AudioStream = preload("res://assets/sounds/77691__joelaudio__sfx_magic_fireball_001.wav")
const sword_sound: AudioStream = preload("res://assets/sounds/422507__nightflame__swinging-staff-whoosh-strong-07.wav")

const SWING_SPEED: float  = 0.2
const ATTACK_SPEED: float = 0.3
const SWORD_BASE_DAMAGE: float = 1

var sword_damage_multiplier: float = 1

const MAGIC_BASE_DAMAGE: float = 1
const MAGIC_BASE_MOVEMENT_SPEED: float = 200

var magic_damage_multiplier: float = 1
var magic_speed_multiplier: float = 1
#var magic_size:int = 1

var magic_mode = false
var can_attack = true

func _ready():
	hurt_box.visible = false
	collision_shape.disabled = true
	
func attack(direction: Vector2):
	if can_attack:
		rotation = direction.angle()
		if magic_mode and $"..".flowers > 0:
			$AudioStreamPlayer2D.stream = fireball_sound
			$AudioStreamPlayer2D.play(0.3)
			var fireball: Projectile = fireball_scene.instantiate()
			fireball.movement_direction = direction
			fireball.movement_speed = MAGIC_BASE_MOVEMENT_SPEED * magic_speed_multiplier
			fireball.damage = MAGIC_BASE_DAMAGE * magic_damage_multiplier
			get_tree().root.add_child(fireball)
			fireball.global_position = $HurtBox.global_position
			$"..".flowers -= 1
		else:
			$AudioStreamPlayer2D.stream = sword_sound
			$AudioStreamPlayer2D.play(0.1)
			hurt_box.damage = SWORD_BASE_DAMAGE * sword_damage_multiplier
			hurt_box.visible = true
			collision_shape.disabled = false
		swing_timer.start(SWING_SPEED)
		can_attack = false

func _on_swing_timer_timeout():
	hurt_box.visible = false
	collision_shape.disabled = true
	can_attack = true
