
extends StaticBody2D

var jugador_cerca: bool = false
var abierta: bool = false
var abriendo: bool = false

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D


func _ready():
	animacion.play("closed")


func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		abrir_puerta()


func abrir_puerta():
	if abierta or abriendo:
		return

	abriendo = true

	animacion.play("open")
	await animacion.animation_finished

	animacion.play("opened")

	colision.set_deferred("disabled", true)

	abierta = true
	abriendo = false


func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		jugador_cerca = true


func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		jugador_cerca = false
