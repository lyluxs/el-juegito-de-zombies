
extends CanvasLayer

@onready var texto: Label = $TextoPuerta

var mensaje_activo: bool = false
var animacion: Tween


func _ready():
	texto.hide()
	texto.pivot_offset = texto.size / 2.0


func mostrar_mensaje(mensaje: String):
	if mensaje_activo:
		return

	mensaje_activo = true
	texto.text = mensaje
	texto.show()

	texto.scale = Vector2(0.4, 0.4)
	texto.modulate.a = 0.0
	texto.pivot_offset = texto.size / 2.0


	animacion = create_tween()
	animacion.set_parallel(true)
	animacion.tween_property(
		texto, "scale", Vector2.ONE, 0.35
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	animacion.tween_property(
		texto, "modulate:a", 1.0, 0.2
	)

	await animacion.finished

	await get_tree().create_timer(1.5).timeout

	animacion = create_tween()
	animacion.set_parallel(true)
	animacion.tween_property(
		texto, "modulate:a", 0.0, 0.3
	)
	animacion.tween_property(
		texto, "scale", Vector2(0.7, 0.7), 0.3
	)

	await animacion.finished

	texto.hide()
	texto.scale = Vector2.ONE
	texto.modulate.a = 1.0
	mensaje_activo = false
