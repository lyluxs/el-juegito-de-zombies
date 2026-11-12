
extends CharacterBody2D

signal vida_cambiada(vida: int)

@export var speed := 50.0

var vida_maxima: int = 6
var vida_actual: int = 6
var invulnerable: bool = false
var muerto: bool = false


func _ready() -> void:
	add_to_group("player")
	vida_cambiada.emit(vida_actual)


func _physics_process(_delta: float) -> void:
	if muerto:
		velocity = Vector2.ZERO
		return

	# Movimiento
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	# Orientación según el cursor del mouse
	var mouse_direction = get_global_mouse_position() - global_position

	if mouse_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif mouse_direction.x < 0:
		$AnimatedSprite2D.flip_h = true

	# Animaciones
	if direction != Vector2.ZERO:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

	# Aplicar movimiento
	velocity = direction * speed
	move_and_slide()


func recibir_golpe() -> void:
	if invulnerable or muerto:
		return

	vida_actual = max(vida_actual - 1, 0)
	vida_cambiada.emit(vida_actual)

	print("Vida del jugador: ", vida_actual)

	if vida_actual <= 0:
		muerto = true
		velocity = Vector2.ZERO
		print("GAME OVER")

		get_tree().call_deferred(
			"change_scene_to_file",
			"res://gameover.tscn"
		)
		return

	invulnerable = true

	# Efecto de parpadeo al recibir daño
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	var tiempo_parpadeo := 0.5
	var intervalo := 0.08
	var tiempo_transcurrido := 0.0

	while tiempo_transcurrido < tiempo_parpadeo:
		sprite.modulate = Color.WHITE
		await get_tree().create_timer(intervalo).timeout

		sprite.modulate = Color(1.0, 0.35, 0.35)
		await get_tree().create_timer(intervalo).timeout

		tiempo_transcurrido += intervalo * 2

	sprite.modulate = Color.WHITE

	await get_tree().create_timer(0.8 - tiempo_parpadeo).timeout
	invulnerable = false
