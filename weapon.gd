
extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2

@onready var sprite: Sprite2D = $Sprite2D
@onready var bullet_spawn: Node2D = $BulletSpawn

var can_shoot: bool = true


func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position

	rotation = direction.angle()

	sprite.flip_v = direction.x < 0


	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()


func shoot():
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
