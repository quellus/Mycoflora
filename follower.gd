extends CharacterBody2D

@onready var game = $"../.."
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@onready var sprite: AnimatedSprite2D = $"Doggo-walking"
@onready var wander_timer: Timer = $WanderTimer

var target_position: Vector2 = Vector2.ZERO
var chillin = false
var wander = false
const SPEED: int = 50

func _physics_process(_delta: float) -> void:
	if game.player:

		if global_position.distance_to(game.player.global_position) > 50:
			nav_agent.target_position = game.player.global_position
			var next_pos = nav_agent.get_next_path_position()
			chillin = false
			velocity = velocity.lerp(global_position.direction_to(next_pos) * SPEED, 0.05)
		else:
			chillin = true
			if wander:
				if nav_agent.is_navigation_finished():
					wander_pos()
				var next_pos = nav_agent.get_next_path_position()
				velocity = velocity.lerp(global_position.direction_to(next_pos) * SPEED * 0.5, 0.05)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.y = move_toward(velocity.y, 0, SPEED)
		
		if velocity == Vector2.ZERO:
			sprite.play("default")
		else:
			sprite.play("walk")
		
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
	move_and_slide()


func wander_pos() -> void:
	var pos = (Vector2.RIGHT * randf_range(10,50)).rotated(randf() * TAU)
	nav_agent.target_position = pos + game.player.global_position


func _toggle_wander() -> void:
	wander = !wander
	if wander and chillin:
		wander_pos()
	wander_timer.start(randf_range(0.5, 4))
