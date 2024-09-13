class_name Player extends CharacterBody2D

@onready var weapon = $Weapon
@onready var sprite = $AnimatedSprite2D
@onready var camera = %Camera2D

signal health_changed(health)
signal flower_count_changed(value: int)
signal player_died()
signal warp(destination: String, spawn_point: int)
signal dialog_trigger(Array)

var save_data = {
	"learned_magic": false,
	"has_weapon": false,
	"flowers": 10
}

var in_dialog: bool = false
var learned_magic: bool = false
var has_weapon: bool = false
var last_move_direction: Vector2
var health: int = 10
var knockback: bool = false
var flowers: int = 10:
	set(value):
		flowers = value
		flower_count_changed.emit(value)

const SPEED: float = 75.0

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	var camera_position
	if !knockback:
		if direction and !in_dialog:
			last_move_direction = direction
			camera_position = direction * 10
			velocity = direction * SPEED
			if direction.x > 0:
				sprite.flip_h = false
			elif direction.x < 0:
				sprite.flip_h = true
			if !sprite.is_playing():
				sprite.play("walk")
		else:
			camera_position = Vector2.ZERO
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			if !sprite.is_playing():
				sprite.play("default")
	else:
		camera_position = Vector2.ZERO
	camera.position = camera.position.lerp(camera_position, 0.05)
	move_and_slide()

func _input(event):
	if event.is_action_pressed("attack"):
		var direction: Vector2
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
			if direction == Vector2.ZERO:
				direction = last_move_direction
		else:
			direction = global_position.direction_to(get_global_mouse_position())
		if has_weapon or learned_magic:
			weapon.attack(direction)
	if event.is_action_pressed("swap_weapons") and learned_magic:
		weapon.magic_mode = !weapon.magic_mode
	if event.is_action_pressed("interact") and !in_dialog:
		for area in %InteractableDetector.get_overlapping_areas():
				if area is Interactable:
					if area is Flower:
						flowers += 1
					elif area is Scythe:
						has_weapon = true
					elif area is Artefact:
						learned_magic = true
					elif area is DialogInteractable:
						in_dialog = true
						dialog_trigger.emit(area.dialogue)
					area.interact()


func take_damage(position_from: Vector2):
	$AnimationPlayer.play("camera_shake")
	health -= 1
	health_changed.emit(health)
	velocity = position.direction_to(position_from) * SPEED * -2
	knockback = true
	$KnockbackTimer.start(0.1)
	sprite.modulate = Color(100,100,100)
	$HurtDetector/CollisionShape2D.call_deferred("set", "disabled", true)
	$iFrameTimer.start(1)
	if health <= 0:
		player_died.emit()


func _on_hurt_detector_area_entered(area):
	if area is HurtBox and !is_ancestor_of(area) and area.entity != "Player":
		take_damage(area.global_position)
	elif area is WarpPoint:
		warp.emit(area.destination, area.spawn_point)


func _on_knockback_timer_timeout():
	sprite.modulate = Color(1,1,1)
	knockback = false


func _on_i_frame_timer_timeout():
	$HurtDetector/CollisionShape2D.disabled = false


func _on_interactable_detector_area_entered(area):
	if area is DialogTrigger:
		in_dialog = true
		dialog_trigger.emit(area.dialogue)
	elif area is Interactable:
		area.highlight(true)


func _on_interactable_detector_area_exited(area):
	if area is Interactable:
		area.highlight(false)
