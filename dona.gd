
extends StaticBody2D

var jugador_cerca: bool = false
var recogida: bool = false

@export var curacion: int = 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D
@onready var area_colision: CollisionShape2D = $Area2D/CollisionShape2D


func _process(_delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		recoger_dona()


func recoger_dona() -> void:
	if recogida:
		return

	var jugador = get_node_or_null("../Player")

	if jugador == null:
		print("No se encontró Player")
		return

	print("Vida antes de la dona: ", jugador.vida_actual)

	if jugador.vida_actual >= jugador.vida_maxima:
		print("¡La vida ya está al máximo!")
		return

	recogida = true

	jugador.vida_actual = mini(
		jugador.vida_actual + curacion,
		jugador.vida_maxima
	)


	jugador.vida_cambiada.emit(jugador.vida_actual)

	print("Vida después de la dona: ", jugador.vida_actual)

	sprite.hide()
	colision.set_deferred("disabled", true)
	area_colision.set_deferred("disabled", true)

	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		jugador_cerca = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		jugador_cerca = false
