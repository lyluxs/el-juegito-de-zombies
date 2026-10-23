
extends Control

@onready var fondo: ColorRect = $Fondo
@onready var titulo: Label = $Titulo
@onready var gracias: Label = $Gracias
@onready var creditos: VBoxContainer = $Creditos


func _ready() -> void:
	fondo.color = Color.BLACK

	titulo.text = "ALPHA COMPLETADA"
	titulo.modulate.a = 0.0
	titulo.pivot_offset = titulo.size / 2.0
	titulo.scale = Vector2(0.95, 0.95)

	gracias.text = "¡Gracias por probar!"
	gracias.modulate.a = 0.0
	creditos.modulate.a = 0.0

	await get_tree().process_frame

	titulo.position.x = (size.x - titulo.size.x) / 2.0
	gracias.position.x = (size.x - gracias.size.x) / 2.0

	var entrada = create_tween()

	entrada.tween_property(
		titulo,
		"modulate:a",
		1.0,
		2.0
	)

	entrada.parallel().tween_property(
		titulo,
		"scale",
		Vector2.ONE,
		1.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	entrada.tween_interval(0.5)

	entrada.tween_property(
		gracias,
		"modulate:a",
		1.0,
		1.5
	)

	entrada.tween_interval(2.0)

	entrada.tween_property(
		titulo,
		"modulate:a",
		0.0,
		1.0
	)

	entrada.parallel().tween_property(
		gracias,
		"modulate:a",
		0.0,
		1.0
	)

	await entrada.finished
	await get_tree().process_frame

	creditos.position.x = (size.x - creditos.size.x) / 2.0
	creditos.position.y = size.y
	creditos.modulate.a = 1.0

	var desplazamiento = create_tween()

	desplazamiento.tween_property(
		creditos,
		"position:y",
		-creditos.size.y,
		35.0
	).set_trans(Tween.TRANS_LINEAR)

	await desplazamiento.finished

	var cierre = create_tween()

	cierre.tween_property(
		creditos,
		"modulate:a",
		0.0,
		1.5
	)
