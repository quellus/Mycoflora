class_name Player extends CharacterBody2D

@onready var weapon = $Weapon
@onready var sprite = $AnimatedSprite2D
@onready var camera = %Camera2D
@onready var audio_stream_player = $AudioStreamPlayer

signal health_changed(max_health: int, health: int)
signal flower_count_changed(value: int)
signal sword_level_changed(value: int)
signal player_died()
signal warp(destination: String, spawn_point: int)
signal dialog_trigger(String)

var in_dialog: bool = false
var last_move_direction: Vector2
var max_health: int = 5
var health: int = 5
var knockback: bool = false

var killed_boss: bool:
	get():
		return SaveLoad.data["players"]["player1"]["killed_boss"]
	set(value):
		killed_boss = value
		SaveLoad.data["players"]["player1"]["killed_boss"] = value
var has_weapon: bool:
	get():
		return SaveLoad.data["players"]["player1"]["has_weapon"]
	set(value):
		has_weapon = value
		SaveLoad.data["players"]["player1"]["has_weapon"] = value
var flowers: int = 10:
	get():
		return SaveLoad.data["players"]["player1"]["flowers"]
	set(value):
		flowers = value
		SaveLoad.data["players"]["player1"]["flowers"] = value
		flower_count_changed.emit(value)

var sword_level: int = 0:
	set(value):
		sword_level = value
		sword_level_changed.emit(value)

const SPEED: float = 75.0
var speed_modifier: float = 1

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	var camera_position
	if !knockback:
		if direction and !in_dialog:
			last_move_direction = direction
			camera_position = direction * 10
			velocity = direction * SPEED * speed_modifier
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
	if event.is_action_pressed("sprint"):
		if OS.has_feature("editor"):
			if speed_modifier > 1:
				speed_modifier = 1
			else:
				speed_modifier = 5
		
	if event.is_action_pressed("attack") and !in_dialog:
		var direction: Vector2
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
			if direction == Vector2.ZERO:
				direction = last_move_direction
		else:
			direction = global_position.direction_to(get_global_mouse_position())
		if has_weapon or killed_boss:
			weapon.attack(direction)
	if event.is_action_pressed("swap_weapons") and killed_boss:
		weapon.magic_mode = !weapon.magic_mode
	if event.is_action_pressed("interact") and !in_dialog:
		for area in %InteractableDetector.get_overlapping_areas():
				if area is Interactable:
					if area is Flower:
						flowers += 1
					elif area is Scythe:
						has_weapon = true
					elif area is Artefact:
						killed_boss = true
					elif area is DialogInteractable:
						in_dialog = true
						dialog_trigger.emit(area.char_name)
						if area.char_name == "The Old Angy Guy The Real":
							has_weapon = true
					elif area is TreasureChest:
						if area.type == Interactable.ItemTypes.SWORD:
							sword_level += 1
						elif area.type == Interactable.ItemTypes.HEALTH:
							max_health += 1
							heal()
							health_changed.emit(max_health, health)
					area.interact()


func take_damage(position_from: Vector2):
	$AnimationPlayer.play("camera_shake")
	health -= 1
	audio_stream_player.play()
	health_changed.emit(max_health, health)
	velocity = position.direction_to(position_from) * SPEED * -2
	knockback = true
	$KnockbackTimer.start(0.1)
	sprite.modulate = Color(100,100,100)
	$HurtDetector/CollisionShape2D.call_deferred("set", "disabled", true)
	$iFrameTimer.start(1)
	if health <= 0:
		player_died.emit()


func heal():
	health = max_health
	health_changed.emit(max_health, health)


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
	if area is Interactable:
		area.highlight(true)


func _on_interactable_detector_area_exited(area):
	if area is Interactable:
		area.highlight(false)
