
extends CharacterBody2D

signal health_changed(health: int)

@export var speed := 80.0

var max_health: int = 6
var current_health: int = 6

var invulnerable: bool = false
var dead: bool = false
var message_active: bool = false


func _ready() -> void:
	add_to_group("player")
	health_changed.emit(current_health)


func _physics_process(_delta: float) -> void:
	if dead:
		velocity = Vector2.ZERO
		return

	# Movement
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	# Mouse orientation
	var mouse_direction = get_global_mouse_position() - global_position

	if mouse_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif mouse_direction.x < 0:
		$AnimatedSprite2D.flip_h = true

	# Animations
	if direction != Vector2.ZERO:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

	# Movement
	velocity = direction * speed
	move_and_slide()


func receive_damage() -> void:
	if invulnerable or dead:
		return

	current_health = max(current_health - 1, 0)
	health_changed.emit(current_health)

	print("Player health: ", current_health)

	if current_health <= 0:
		dead = true
		velocity = Vector2.ZERO
		print("GAME OVER")

		get_tree().call_deferred(
			"change_scene_to_file",
			"res://gameover.tscn"
		)
		return

	invulnerable = true

	# Damage blink effect
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	var blink_duration := 0.5
	var interval := 0.08
	var elapsed := 0.0

	while elapsed < blink_duration:
		sprite.modulate = Color.WHITE
		await get_tree().create_timer(interval).timeout

		sprite.modulate = Color(1.0, 0.35, 0.35)
		await get_tree().create_timer(interval).timeout

		elapsed += interval * 2

	sprite.modulate = Color.WHITE

	await get_tree().create_timer(0.8 - blink_duration).timeout
	invulnerable = false


func restore_health(amount: int = 1) -> bool:
	if dead:
		return false

	if current_health >= max_health:
		show_health_message()
		return false

	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health)

	print("Health restored: ", current_health)

	return true


func show_health_message() -> void:
	if message_active:
		return

	message_active = true

	var message = get_tree().get_first_node_in_group("health_message")

	if message == null:
		push_warning("Health message Label not found!")
		message_active = false
		return

	message.text = "La vida esta llena!"
	message.visible = true

	message.pivot_offset = message.size / 2
	message.scale = Vector2(0.7, 0.7)
	message.modulate.a = 0.0

	# Entrance animation
	var tween = create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		message,
		"scale",
		Vector2.ONE,
		0.25
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		message,
		"modulate:a",
		1.0,
		0.25
	)

	await tween.finished

	# Wait
	await get_tree().create_timer(1.5).timeout

	# Exit animation
	var exit_tween = create_tween()

	exit_tween.set_parallel(true)

	exit_tween.tween_property(
		message,
		"modulate:a",
		0.0,
		0.3
	)

	exit_tween.tween_property(
		message,
		"scale",
		Vector2(0.8, 0.8),
		0.3
	)

	await exit_tween.finished

	if is_instance_valid(message):
		message.visible = false
		message.scale = Vector2.ONE
		message.modulate.a = 1.0

	message_active = false
