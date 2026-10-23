
extends CanvasLayer

@onready var fondo: Node2D = $Fondo
@onready var oscurecimiento: ColorRect = $Fondo/Oscurecimiento
@onready var texto_perdiste: TextureRect = $Fondo/TextoPerdiste
@onready var boton_reiniciar: TextureButton = $Fondo/BotonReiniciar
@onready var boton_salir: TextureButton = $Fondo/BotonSalir

var game_over_activo: bool = false


func _ready() -> void:
	fondo.show()

	oscurecimiento.color = Color(0, 0, 0, 0)

	boton_reiniciar.hide()
	boton_salir.hide()

	mostrar_game_over()


func mostrar_game_over() -> void:
	if game_over_activo:
		return

	game_over_activo = true

	texto_perdiste.pivot_offset = texto_perdiste.size / 2.0
	texto_perdiste.scale = Vector2(0.1, 0.1)
	texto_perdiste.modulate.a = 0.0

	for boton in [boton_reiniciar, boton_salir]:
		boton.pivot_offset = boton.size / 2.0
		boton.scale = Vector2(0.5, 0.5)
		boton.modulate.a = 0.0

	var tween = create_tween()

	tween.tween_property(
		oscurecimiento,
		"color:a",
		0.78,
		0.5
	)

	tween.parallel().tween_property(
		texto_perdiste,
		"scale",
		Vector2(1.2, 1.2),
		0.65
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		texto_perdiste,
		"modulate:a",
		1.0,
		0.4
	)

	tween.tween_property(
		texto_perdiste,
		"scale",
		Vector2(0.95, 0.95),
		0.12
	)

	tween.tween_property(
		texto_perdiste,
		"scale",
		Vector2.ONE,
		0.16
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_interval(0.2)

	tween.tween_callback(boton_reiniciar.show)

	tween.tween_property(
		boton_reiniciar,
		"scale",
		Vector2(1.1, 1.1),
		0.3
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		boton_reiniciar,
		"modulate:a",
		1.0,
		0.25
	)

	tween.tween_property(
		boton_reiniciar,
		"scale",
		Vector2.ONE,
		0.12
	)

	tween.tween_interval(0.12)

	tween.tween_callback(boton_salir.show)

	tween.tween_property(
		boton_salir,
		"scale",
		Vector2(1.1, 1.1),
		0.3
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(
		boton_salir,
		"modulate:a",
		1.0,
		0.25
	)

	tween.tween_property(
		boton_salir,
		"scale",
		Vector2.ONE,
		0.12
	)


func _on_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file(
        "res://nivel_de_prueba.tscn"
	)


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_boton_reiniciar_mouse_entered() -> void:
	animar_boton(boton_reiniciar, Vector2(1.15, 1.15))


func _on_boton_reiniciar_mouse_exited() -> void:
	animar_boton(boton_reiniciar, Vector2.ONE)


func _on_boton_salir_mouse_entered() -> void:
	animar_boton(boton_salir, Vector2(1.15, 1.15))


func _on_boton_salir_mouse_exited() -> void:
	animar_boton(boton_salir, Vector2.ONE)


func animar_boton(
	boton: TextureButton,
	escala: Vector2
) -> void:
	var tween = create_tween()

	tween.tween_property(
		boton,
		"scale",
		escala,
		0.15
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
