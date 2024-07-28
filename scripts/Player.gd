class_name Player extends CharacterBody2D

@onready var weapon = $Weapon
@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D

signal health_changed(health)

var health = 10

var knockback = false

const SPEED = 75.0

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	var camera_position
	if !knockback:
		if direction:
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
	#camera.position = camera_position
	move_and_slide()

func _input(event):
	if event.is_action_pressed("attack"):
		weapon.attack()

func take_damage(position_from: Vector2):
	health -= 1
	health_changed.emit(health)
	velocity = position.direction_to(position_from) * SPEED * -2
	knockback = true
	$KnockbackTimer.start(0.1)
	sprite.modulate = Color(100,100,100)
	$HurtDetector/CollisionShape2D.call_deferred("set", "disabled", true)
	$iFrameTimer.start(1)
	if health <= 0:
		get_tree().quit()


func _on_hurt_detector_area_entered(area):
	if area is HurtBox and !is_ancestor_of(area):
		take_damage(area.global_position)


func _on_knockback_timer_timeout():
	sprite.modulate = Color(1,1,1)
	knockback = false


func _on_i_frame_timer_timeout():
	$HurtDetector/CollisionShape2D.disabled = false
	
