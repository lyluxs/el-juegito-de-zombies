
extends CharacterBody2D

signal jefe_muerto

@export_group("Estadísticas")
@export var velocidad: float = 20.0
@export var vida: int = 30
@export var tiempo_entre_ataques: float = 1.5

@export_group("Combate")
@export var dano: int = 2

var objetivo: Node2D = null
var jugador_en_rango: Node2D = null

var puede_atacar: bool = true
var recibiendo_dano: bool = false
var muriendo: bool = false

var perseguir_por_disparo: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.play("idle")


func _physics_process(_delta: float) -> void:

	if recibiendo_dano or muriendo:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if not is_instance_valid(objetivo):
		objetivo = null
		perseguir_por_disparo = false

	if is_instance_valid(objetivo):

		var direccion = global_position.direction_to(
			objetivo.global_position
		)

		velocity = direccion * velocidad
		move_and_slide()

		if direccion.x != 0:
			animated_sprite.flip_h = direccion.x > 0

		animated_sprite.play("Walk")

	else:
		velocity = Vector2.ZERO
		move_and_slide()

		animated_sprite.play("idle")


func _on_detection_area_body_entered(body: Node2D) -> void:

	if body.is_in_group("player") and not muriendo:
		objetivo = body
		print("JEFE: PLAYER DETECTADO")


func _on_detection_area_body_exited(body: Node2D) -> void:

	if body == objetivo:
		if not perseguir_por_disparo:
			objetivo = null


func _on_attack_area_body_entered(body: Node2D) -> void:

	if body.is_in_group("player") and not muriendo:
		jugador_en_rango = body
		atacar_repetidamente()


func _on_attack_area_body_exited(body: Node2D) -> void:

	if body == jugador_en_rango:
		jugador_en_rango = null


func atacar_repetidamente() -> void:

	if not puede_atacar or muriendo:
		return

	puede_atacar = false

	while is_inside_tree() and not muriendo:

		if not is_instance_valid(jugador_en_rango):
			break

		if jugador_en_rango.has_method("recibir_golpe"):
			jugador_en_rango.recibir_golpe()

		await get_tree().create_timer(
			tiempo_entre_ataques
		).timeout

	puede_atacar = true


func recibir_golpe() -> void:

	if vida <= 0 or recibiendo_dano or muriendo:
		return

	var jugador = get_tree().get_first_node_in_group("player")

	if is_instance_valid(jugador):
		objetivo = jugador
		perseguir_por_disparo = true

	recibiendo_dano = true
	vida -= 1

	print("Vida del JEFE: ", vida)

	if vida <= 0:
		morir()
		return

	animated_sprite.modulate = Color.RED

	await get_tree().create_timer(0.12).timeout

	if not is_inside_tree():
		return

	animated_sprite.modulate = Color.WHITE

	recibiendo_dano = false


func morir() -> void:

	if muriendo:
		return

	muriendo = true
	recibiendo_dano = false

	jefe_muerto.emit()

	objetivo = null
	jugador_en_rango = null
	velocity = Vector2.ZERO

	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

	$DetectionArea.set_deferred("monitoring", false)
	$AttackArea.set_deferred("monitoring", false)

	animated_sprite.modulate = Color.WHITE
	animated_sprite.play("Death")

	await animated_sprite.animation_finished

	if is_inside_tree():
		queue_free()


func _exit_tree() -> void:

	jugador_en_rango = null
	objetivo = null
