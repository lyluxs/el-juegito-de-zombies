
extends StaticBody2D

var jugador_cerca: bool = false
var abierta: bool = false
var abriendo: bool = false

var zona: Node2D = null
var desbloqueada: bool = false

#miau
var mensajes: CanvasLayer = null

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D


func _ready():
	animacion.play("closed")


func _process(_delta):
	comprobar_zombies()

	if jugador_cerca and Input.is_action_just_pressed("interactuar"):
		if not desbloqueada:
			if mensajes:
				mensajes.mostrar_mensaje(
					"NUH HUH! MATA A TODOS LOS ZOMBIES PRIMERO"
				)
			else:
				print("¡Todavía quedan zombies en esta zona!")
			return

		abrir_puerta()


func comprobar_zombies():
	if desbloqueada or zona == null:
		return

	var zombies = zona.find_children(
		"*", "CharacterBody2D", true, false
	)

	for zombie in zombies:
		if zombie.is_in_group("zombies"):
			return

	desbloqueada = true
	print("¡Puerta desbloqueada!")


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
	if body.is_in_group("player"):
		jugador_cerca = true


func _on_interaction_area_body_exited(body):
	if body.is_in_group("player"):
		jugador_cerca = false
