
extends CanvasLayer

# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#             TUTORIAL SYSTEM
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡

@onready var message: Label = $Mensaje

var step: int = 0
var animation: Tween
var original_position: Vector2


# ─────────── INITIALIZATION ───────────

func _ready() -> void:
	add_to_group("tutorial")

	message.position = Vector2.ZERO
	message.size = Vector2(230, message.size.y)
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	original_position = Vector2(
		(240.0 - message.size.x) / 2.0,
		160.0 - message.size.y - 5.0
	)

	message.position = original_position
	message.pivot_offset = message.size / 2.0
	message.text = "Dispara al zombie con clic izquierdo"
	message.hide()

	# ♡ Connect first zombie
	var zombie = get_tree().current_scene.find_child(
		"Zombie", true, false
	)

	if zombie:
		if zombie.has_signal("zombie_dead"):
			zombie.zombie_dead.connect(first_zombie_killed)
		else:
			push_warning("PrimerZombie no tiene la señal zombie_dead.")
	else:
		push_warning("No se encontró Zombie en la escena.")

	show_message()


# ─────────── SHOW MESSAGE ───────────

func show_message() -> void:
	if animation and animation.is_running():
		animation.kill()

	message.position = original_position + Vector2(0, 10)
	message.scale = Vector2(0.8, 0.8)
	message.modulate.a = 0.0
	message.show()

	animation = create_tween()
	animation.set_parallel(true)

	animation.tween_property(
		message, "position", original_position, 0.35
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	animation.tween_property(
		message, "scale", Vector2.ONE, 0.35
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	animation.tween_property(
		message, "modulate:a", 1.0, 0.25
	)


# ─────────── HIDE MESSAGE ───────────

func hide_message() -> void:
	if animation and animation.is_running():
		animation.kill()

	animation = create_tween()
	animation.set_parallel(true)

	animation.tween_property(
		message, "scale", Vector2(0.85, 0.85), 0.2
	)

	animation.tween_property(
		message, "modulate:a", 0.0, 0.2
	)

	animation.chain().tween_callback(message.hide)


# ─────────── FIRST ZOMBIE DEFEATED ───────────

func first_zombie_killed() -> void:
	if step != 0:
		return

	step = 1

	hide_message()
	await animation.finished

	if step != 1:
		return

	message.text = "Interactua con E para abrir la puerta"
	show_message()

	await get_tree().create_timer(4.0).timeout

	if step == 1:
		finish_tutorial()


# ─────────── FINISH TUTORIAL ───────────

func finish_tutorial() -> void:
	if step >= 2:
		return

	step = 2
	hide_message()


# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#              END OF FILE
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
