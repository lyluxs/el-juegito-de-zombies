
extends Area2D

@export var speed: float = 100.0
@export var damage: int = 1

var direction: Vector2 = Vector2.RIGHT
var impacted: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	direction = direction.normalized()
	rotation = direction.angle()

	animated_sprite.play("Shoot")


func _physics_process(delta: float) -> void:
	if impacted:
		return

	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if impacted:
		return

	if body.is_in_group("zombies"):
		if body.has_method("recibir_golpe"):
			body.recibir_golpe()

		play_impact()

	elif body is TileMapLayer or body is StaticBody2D:
		play_impact()


func play_impact() -> void:
	impacted = true

	# Stop detecting collisions
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

	animated_sprite.play("Impact")

	await animated_sprite.animation_finished

	queue_free()
