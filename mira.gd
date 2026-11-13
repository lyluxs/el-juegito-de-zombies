
extends Node2D

# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#             CURSOR SYSTEM
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡

# ─────────── CURSOR TEXTURES ───────────

@export_group("Cursor Textures")
@export var normal_texture: Texture2D
@export var red_texture: Texture2D

# ─────────── NODES ───────────

@onready var sprite: Sprite2D = $Sprite2D

# ─────────── CURSOR STATUS ───────────

var aiming_at_zombie: bool = false


# ─────────── INITIALIZATION ───────────

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	sprite.texture = normal_texture


# ─────────── CURSOR MOVEMENT ───────────

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

	var new_state := is_cursor_over_zombie()

	if new_state != aiming_at_zombie:
		aiming_at_zombie = new_state

		if aiming_at_zombie:
			sprite.texture = red_texture
		else:
			sprite.texture = normal_texture


# ─────────── ZOMBIE DETECTION ───────────

func is_cursor_over_zombie() -> bool:
	var space = get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var results = space.intersect_point(query, 32)

	for result in results:
		var object = result.collider

		if object is Node and object.is_in_group("zombies"):
			return true

		if object is Node:
			var parent = object.get_parent()

			while parent != null:
				if parent.is_in_group("zombies"):
					return true

				parent = parent.get_parent()

	return false


# ─────────── CLEANUP ───────────

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#              END OF FILE
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
