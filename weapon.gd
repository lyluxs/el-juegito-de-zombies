
extends Node2D

# ♡ ───── WEAPON SETTINGS ───── ♡

@export_group("Weapon Stats")
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2

# ♡ ───── NODES ───── ♡

@onready var sprite: Sprite2D = $Sprite2D
@onready var bullet_spawn: Node2D = $BulletSpawn

# ♡ ───── WEAPON STATUS ───── ♡

var can_shoot: bool = true


# ♡ ───── AIM & SHOOTING ───── ♡

func _process(_delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position

	# ♡ 360-degree aiming
	rotation = direction.angle()

	# ♡ Prevent the weapon from flipping upside down
	sprite.flip_v = direction.x < 0

	# ♡ Keep the weapon in front of the player
	z_index = 1

	# ♡ Shoot when the input is pressed
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()


# ♡ ───── BULLET CREATION ───── ♡

func shoot() -> void:
	if bullet_scene == null:
		print("ERROR: No asignaste bullet.tscn")
		return

	can_shoot = false

	var bullet = bullet_scene.instantiate()

	bullet.direction = (
		get_global_mouse_position() - bullet_spawn.global_position
	).normalized()

	get_tree().current_scene.add_child(bullet)
	bullet.global_position = bullet_spawn.global_position

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
