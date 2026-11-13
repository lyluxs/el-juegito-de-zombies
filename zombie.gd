
extends CharacterBody2D

signal zombie_muerto

@export_group("Statistics")
@export var velocidad: float = 30.0
@export var vida: int = 3
@export var tiempo_entre_ataques: float = 2.0

@export_group("Appearance")
@export_enum(
	"Normal",
	"Silly",
	"Javi",
	"Franco",
	"Fede",
	"Gaucho",
	"Amarillo"
)
var tipo_skin: int = 0

@export var skins: Array[SpriteFrames] = []

var objetivo: Node2D = null
var jugador_en_rango: Node2D = null

var puede_atacar: bool = true
var recibiendo_dano: bool = false
var muriendo: bool = false

var perseguir_por_disparo: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	aplicar_skin()
	animated_sprite.play("idle")


func aplicar_skin() -> void:

	print("Selecting skin: ", tipo_skin)
	print("Number of skins: ", skins.size())

	if tipo_skin < 0 or tipo_skin >= skins.size():
		push_warning("Skin index does not exist")
		return

	if skins[tipo_skin] == null:
		push_warning("Selected skin is empty")
		return

	animated_sprite.sprite_frames = skins[tipo_skin]

	print("Skin applied successfully: ", tipo_skin)


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
		print("PLAYER DETECTED")


func _on_detection_area_body_exited(body: Node2D) -> void:

	if body == objetivo:
		if not perseguir_por_disparo:
			objetivo = null
			print("PLAYER LEFT DETECTION AREA")


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

		if jugador_en_rango.has_method("receive_damage"):
			jugador_en_rango.receive_damage()

		await get_tree().create_timer(
			tiempo_entre_ataques
		).timeout

	puede_atacar = true


func recibir_golpe() -> void:

	if vida <= 0 or recibiendo_dano or muriendo:
		return

	var jugador = get_tree().get_first_node_in_group("player")

	if is_instance_valid(jugador) and jugador is Node2D:
		objetivo = jugador
		perseguir_por_disparo = true
		print("ZOMBIE ALERTED!")

	recibiendo_dano = true
	vida -= 1

	print("Zombie health: ", vida)

	if vida <= 0:
		morir()
		return

	animated_sprite.play("Damage")
	await animated_sprite.animation_finished

	if not is_inside_tree():
		return

	recibiendo_dano = false


func morir() -> void:

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


func _exit_tree() -> void:

	jugador_en_rango = null
	objetivo = null
