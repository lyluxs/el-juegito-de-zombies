
extends CanvasLayer

@export var corazon_lleno: Texture2D
@export var corazon_mitad: Texture2D
@export var corazon_vacio: Texture2D

@onready var corazones: Array[TextureRect] = [
	$HBoxContainer/Heart1,
	$HBoxContainer/Heart2,
	$HBoxContainer/Heart3
]


func _ready():
	var jugador = get_tree().get_first_node_in_group("player")

	if jugador:
		jugador.vida_cambiada.connect(actualizar_vida)
		actualizar_vida(jugador.vida_actual)
	else:
		push_warning("No se encontró al jugador en el grupo player")


func actualizar_vida(vida: int):
	for i in range(corazones.size()):
		var vida_corazon = vida - (i * 2)

		if vida_corazon >= 2:
			corazones[i].texture = corazon_lleno
		elif vida_corazon == 1:
			corazones[i].texture = corazon_mitad
		else:
			corazones[i].texture = corazon_vacio
