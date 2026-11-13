
extends Area2D

# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#          BULLET SYSTEM
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡

@export_group("Bullet Stats")
@export var speed: float = 200.0
@export var damage: int = 1

# ♡ Movement
var direction: Vector2 = Vector2.RIGHT
var impacted: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# ─────────── INITIALIZATION ───────────

func _ready() -> void:
	direction = direction.normalized()
	rotation = direction.angle()

	animated_sprite.play("Shoot")


# ─────────── MOVEMENT ───────────

func _physics_process(delta: float) -> void:
	if impacted:
		return

	global_position += direction * speed * delta


# ─────────── COLLISION ───────────

func _on_body_entered(body: Node2D) -> void:
	if impacted:
		return

	# ♡ Damage enemies and boss
	if body.has_method("receive_damage"):
		body.receive_damage(damage)
		play_impact()

	# ♡ Walls and obstacles
	elif body is TileMapLayer or body is StaticBody2D:
		play_impact()


# ─────────── IMPACT ANIMATION ───────────

func play_impact() -> void:
	impacted = true

	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

	animated_sprite.play("Impact")

	await animated_sprite.animation_finished

	if is_inside_tree():
		queue_free()


# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#             END OF FILE
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
