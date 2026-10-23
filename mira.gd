extends Node2D

@export var textura_normal: Texture2D
@export var textura_roja: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

var apuntando_a_zombie: bool = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	sprite.texture = textura_normal


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

	var nuevo_estado := cursor_sobre_zombie()

	if nuevo_estado != apuntando_a_zombie:
		apuntando_a_zombie = nuevo_estado

		if apuntando_a_zombie:
			sprite.texture = textura_roja
		else:
			sprite.texture = textura_normal


func cursor_sobre_zombie() -> bool:
	var espacio := get_world_2d().direct_space_state

	var consulta := PhysicsPointQueryParameters2D.new()
	consulta.position = get_global_mouse_position()
	consulta.collide_with_areas = true
	consulta.collide_with_bodies = true

	var resultados := espacio.intersect_point(consulta, 32)

	for resultado in resultados:
		var objeto = resultado.collider

		if objeto is Node and objeto.is_in_group("zombies"):
			return true

		if objeto is Node:
			var padre = objeto.get_parent()

			while padre != null:
				if padre.is_in_group("zombie"):
					return true

				padre = padre.get_parent()

	return false


func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
