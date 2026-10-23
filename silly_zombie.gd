
extends CharacterBody2D
signal zombie_muerto
@export var velocidad: float = 30.0
@export var vida: int = 3
@export var tiempo_entre_ataques: float = 2.0

var objetivo: Node2D = null
var jugador_en_rango: Node2D = null
var puede_atacar: bool = true
var recibiendo_dano: bool = false
var muriendo: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta):
	if recibiendo_dano or muriendo:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if is_instance_valid(objetivo):
		var direccion = global_position.direction_to(
			objetivo.global_position
		)

		velocity = direccion * velocidad
		move_and_slide()
		animated_sprite.play("Walk")
	else:
		objetivo = null
		velocity = Vector2.ZERO
		move_and_slide()
		animated_sprite.play("idle")


func _on_detection_area_body_entered(body):
	if body.is_in_group("player") and not muriendo:
		objetivo = body
		print("PLAYER DETECTADO")


func _on_detection_area_body_exited(body):
	if body == objetivo:
		objetivo = null
		print("PLAYER SALIÓ DEL ÁREA")


func _on_attack_area_body_entered(body):
	if body.is_in_group("player") and not muriendo:
		jugador_en_rango = body
		atacar_repetidamente()


func _on_attack_area_body_exited(body):
	if body == jugador_en_rango:
		jugador_en_rango = null


func atacar_repetidamente():
	if not puede_atacar or muriendo:
		return

	puede_atacar = false

	while is_inside_tree() and not muriendo:
		if not is_instance_valid(jugador_en_rango):
			break

		if jugador_en_rango.has_method("recibir_golpe"):
			jugador_en_rango.recibir_golpe()

		await get_tree().create_timer(tiempo_entre_ataques).timeout

	puede_atacar = true


func recibir_golpe():
	if vida <= 0 or recibiendo_dano or muriendo:
		return

	recibiendo_dano = true
	vida -= 1

	print("Vida del zombie: ", vida)

	if vida <= 0:
		morir()
		return

	animated_sprite.play("Damage")
	await animated_sprite.animation_finished

	if not is_inside_tree():
		return

	recibiendo_dano = false


func morir():
	if muriendo:
		return

	muriendo = true
	recibiendo_dano = false
	zombie_muerto.emit()
	objetivo = null
	jugador_en_rango = null
	velocity = Vector2.ZERO

	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

	$DetectionArea.set_deferred("monitoring", false)
	$AttackArea.set_deferred("monitoring", false)

	animated_sprite.play("Death")
	await animated_sprite.animation_finished

	if is_inside_tree():
		queue_free()


func _exit_tree():
	jugador_en_rango = null
	objetivo = null
