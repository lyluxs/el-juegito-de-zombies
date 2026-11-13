
extends StaticBody2D

# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#           COFFEE POWER-UP
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡

# ♡ States
var player_nearby: bool = false
var collected: bool = false

@export_group("Coffee Stats")
@export var speed_boost: float = 90.0
@export var duration: float = 5.0

# ♡ Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var area_collision: CollisionShape2D = $Area2D/CollisionShape2D


# ─────────── INPUT ───────────

func _process(_delta: float) -> void:

	if player_nearby and Input.is_action_just_pressed("interactuar"):
		collect_coffee()


# ─────────── COLLECTION ───────────

func collect_coffee() -> void:

	if collected:
		return

	var player = get_node_or_null("../Player")

	if player == null:
		print("♡ ERROR: Player not found in ../Player")
		return

	collected = true

	print("♡ COFFEE COLLECTED!")

	# ♡ Speed boost
	player.speed += speed_boost

	sprite.hide()

	collision.set_deferred("disabled", true)
	area_collision.set_deferred("disabled", true)

	# ♡ Power-up duration
	await get_tree().create_timer(duration).timeout

	if is_instance_valid(player):
		player.speed -= speed_boost

	print("♡ COFFEE EFFECT ENDED")

	queue_free()


# ─────────── DETECTION ───────────

func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.name == "Player":
		player_nearby = true


func _on_area_2d_body_exited(body: Node2D) -> void:

	if body.name == "Player":
		player_nearby = false


# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#             END OF FILE
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
