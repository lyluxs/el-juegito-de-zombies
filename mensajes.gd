
extends CanvasLayer

# ♡ ───── MESSAGE SYSTEM ───── ♡

@onready var message_label: Label = $TextoPuerta

var message_active: bool = false
var animation: Tween


# ♡ ───── INITIALIZATION ───── ♡

func _ready() -> void:
	message_label.hide()
	message_label.pivot_offset = message_label.size / 2.0


# ♡ ───── SHOW MESSAGE ───── ♡

func show_message(message: String) -> void:
	if message_active:
		return

	message_active = true
	message_label.text = message
	message_label.show()

	message_label.scale = Vector2(0.4, 0.4)
	message_label.modulate.a = 0.0
	message_label.pivot_offset = message_label.size / 2.0

	animation = create_tween()
	animation.set_parallel(true)

	animation.tween_property(
		message_label, "scale", Vector2.ONE, 0.35
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	animation.tween_property(
		message_label, "modulate:a", 1.0, 0.2
	)

	await animation.finished

	await get_tree().create_timer(1.5).timeout

	animation = create_tween()
	animation.set_parallel(true)

	animation.tween_property(
		message_label, "modulate:a", 0.0, 0.3
	)

	animation.tween_property(
		message_label, "scale", Vector2(0.7, 0.7), 0.3
	)

	await animation.finished

	message_label.hide()
	message_label.scale = Vector2.ONE
	message_label.modulate.a = 1.0

	message_active = false
