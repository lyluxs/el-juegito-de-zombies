
extends Node2D

@export_multiline var frase: String = "No tendrias que haber entrado aqui..."
@export var accion_interactuar: String = "interactuar"

@onready var area: Area2D = $AreaInteraccion
@onready var texto: Label = $AreaInteraccion/TextoInteraccion

var jugador_cerca: bool = false
var ya_interactuado: bool = false
var mostrando_frase: bool = false


func _ready() -> void:
	texto.hide()
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if not jugador_cerca or ya_interactuado:
		return

	if Input.is_action_just_pressed(accion_interactuar):
		interactuar()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not ya_interactuado:
		jugador_cerca = true
		texto.text = "E · Interactuar"
		texto.show()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false

		if not mostrando_frase:
			texto.hide()


func interactuar() -> void:
	if ya_interactuado:
		return

	ya_interactuado = true
	mostrando_frase = true
	texto.text = frase
	texto.show()

	await get_tree().create_timer(3.0).timeout

	mostrando_frase = false
	texto.hide()
