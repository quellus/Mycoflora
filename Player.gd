extends CharacterBody2D

@onready var weapon = $Weapon

const SPEED = 300.0

func _process(_delta):
	weapon.look_at(get_global_mouse_position())

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _input(event):
	if event.is_action_pressed("attack"):
		weapon.visible = true
		weapon.process_mode = Node.PROCESS_MODE_INHERIT

func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.queue_free()
