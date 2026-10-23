extends Area2D

var final_iniciado: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if final_iniciado:
		return

	if body.is_in_group("player"):
		final_iniciado = true
		call_deferred("cambiar_al_final")


func cambiar_al_final() -> void:
	get_tree().change_scene_to_file(
		"res://alpha_completada.tscn"
	)
