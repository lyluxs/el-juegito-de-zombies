extends CanvasLayer

@onready var mensaje: Label = $Mensaje

var paso: int = 0
var animacion: Tween
var posicion_original: Vector2

func _ready() -> void:
	add_to_group("tutorial")

	mensaje.position = Vector2.ZERO
	mensaje.size = Vector2(230, mensaje.size.y)
	mensaje.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mensaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	posicion_original = Vector2(
		(240.0 - mensaje.size.x) / 2.0,
		160.0 - mensaje.size.y - 5.0
	)

	mensaje.position = posicion_original
	mensaje.pivot_offset = mensaje.size / 2.0
	mensaje.text = "Dispara al zombie con clic izquierdo"
	mensaje.hide()

	var zombie = get_tree().current_scene.find_child(
		"PrimerZombie", true, false
	)

	if zombie:
		if zombie.has_signal("zombie_muerto"):
			zombie.zombie_muerto.connect(primer_zombi_muerto)
		else:
			push_warning("PrimerZombie no tiene la señal zombie_muerto.")
	else:
		push_warning("No se encontró PrimerZombie en la escena.")

	mostrar_mensaje()


func mostrar_mensaje() -> void:
	if animacion and animacion.is_running():
		animacion.kill()

	mensaje.position = posicion_original + Vector2(0, 10)
	mensaje.scale = Vector2(0.8, 0.8)
	mensaje.modulate.a = 0.0
	mensaje.show()

	animacion = create_tween()
	animacion.set_parallel(true)

	animacion.tween_property(
		mensaje, "position", posicion_original, 0.35
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	animacion.tween_property(
		mensaje, "scale", Vector2.ONE, 0.35
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	animacion.tween_property(
		mensaje, "modulate:a", 1.0, 0.25
	)


func ocultar_mensaje() -> void:
	if animacion and animacion.is_running():
		animacion.kill()

	animacion = create_tween()
	animacion.set_parallel(true)

	animacion.tween_property(
		mensaje, "scale", Vector2(0.85, 0.85), 0.2
	)

	animacion.tween_property(
		mensaje, "modulate:a", 0.0, 0.2
	)

	animacion.chain().tween_callback(mensaje.hide)


func primer_zombi_muerto() -> void:
	if paso != 0:
		return

	paso = 1

	ocultar_mensaje()
	await animacion.finished

	if paso != 1:
		return

	mensaje.text = "Interactua con E para abrir la puerta"
	mostrar_mensaje()

	await get_tree().create_timer(4.0).timeout

	if paso == 1:
		terminar_tutorial()


func terminar_tutorial() -> void:
	if paso >= 2:
		return

	paso = 2
	ocultar_mensaje()
