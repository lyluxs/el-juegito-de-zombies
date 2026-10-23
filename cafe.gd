
extends StaticBody2D

var jugador_cerca: bool = false
var recogido: bool = false

@export var aumento_velocidad: float = 40.0
@export var duracion: float = 5.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D
@onready var area_colision: CollisionShape2D = $Area2D/CollisionShape2D


func _process(_delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		recoger_cafe()


func recoger_cafe() -> void:
	if recogido:
		return

	var jugador = get_node_or_null("../Player")
	if jugador == null:
		print("No se encontró Player en ../Player")
		return
	recogido = true
	jugador.speed += aumento_velocidad
	sprite.hide()
	colision.set_deferred("disabled", true)
	area_colision.set_deferred("disabled", true)
	await get_tree().create_timer(duracion).timeout

	if is_instance_valid(jugador):
		jugador.speed -= aumento_velocidad
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		jugador_cerca = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		jugador_cerca = false
