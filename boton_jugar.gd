extends Area2D

@export var boton_inactivo: Texture2D
@export var boton_presionado: Texture2D
@export var escena_juego: PackedScene

@onready var sprite: Sprite2D = $Sprite2D

var mouse_encima := false

func _ready() -> void:
	sprite.texture = boton_inactivo
	input_pickable = true

func _input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and mouse_encima:
				sprite.texture = boton_presionado
				get_viewport().set_input_as_handled()

			elif not event.pressed and mouse_encima:
				sprite.texture = boton_inactivo
				get_viewport().set_input_as_handled()
				get_tree().change_scene_to_packed(escena_juego)

func _on_mouse_entered() -> void:
	mouse_encima = true

func _on_mouse_exited() -> void:
	mouse_encima = false
	sprite.texture = boton_inactivo
