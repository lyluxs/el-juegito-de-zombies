
extends CharacterBody2D

signal boss_dead

# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#             BOSS ZOMBIE
#          Crazy John - CuteCore
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡

@export_group("Stats")
@export var speed: float = 20.0
@export var health: int = 15
@export var attack_cooldown: float = 1.5

@export_group("Combat")
@export var damage: int = 2

# ♡ Target
var target: Node2D = null
var player_in_range: Node2D = null

# ♡ States
var can_attack: bool = true
var taking_damage: bool = false
var dying: bool = false
var chase_on_hit: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# ─────────── INITIALIZATION ───────────

func _ready() -> void:
	animated_sprite.play("idle")


# ─────────── MOVEMENT ───────────

func _physics_process(_delta: float) -> void:

	if taking_damage or dying:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if not is_instance_valid(target):
		target = null
		chase_on_hit = false

	if is_instance_valid(target):

		var direction = global_position.direction_to(
			target.global_position
		)

		velocity = direction * speed
		move_and_slide()

		if direction.x != 0:
			animated_sprite.flip_h = direction.x > 0

		animated_sprite.play("Walk")

	else:
		velocity = Vector2.ZERO
		move_and_slide()
		animated_sprite.play("idle")


# ─────────── DETECTION ───────────

func _on_detection_area_body_entered(body: Node2D) -> void:

	if body.is_in_group("player") and not dying:
		target = body
		print("♡ BOSS: PLAYER DETECTED")


func _on_detection_area_body_exited(body: Node2D) -> void:

	if body == target and not chase_on_hit:
		target = null


# ─────────── ATTACK ───────────

func _on_attack_area_body_entered(body: Node2D) -> void:

	if body.is_in_group("player") and not dying:
		player_in_range = body
		attack_repeatedly()


func _on_attack_area_body_exited(body: Node2D) -> void:

	if body == player_in_range:
		player_in_range = null


func attack_repeatedly() -> void:

	if not can_attack or dying:
		return

	can_attack = false

	while is_inside_tree() and not dying:

		if not is_instance_valid(player_in_range):
			break

		if player_in_range.has_method("receive_damage"):
			player_in_range.receive_damage()

		await get_tree().create_timer(
			attack_cooldown
		).timeout

	can_attack = true


# ─────────── DAMAGE ───────────

func receive_damage(amount: int = 1) -> void:

	if health <= 0 or dying:
		return

	var player = get_tree().get_first_node_in_group("player")

	if is_instance_valid(player):
		target = player
		chase_on_hit = true

	health = max(health - amount, 0)

	print("♡ BOSS RECEIVED DAMAGE: ", amount)
	print("♡ BOSS REMAINING HEALTH: ", health)

	if health <= 0:
		die()
		return

	if taking_damage:
		return

	taking_damage = true

	# ♡ Red damage flash
	animated_sprite.modulate = Color.RED

	await get_tree().create_timer(0.12).timeout

	if not is_inside_tree():
		return

	animated_sprite.modulate = Color.WHITE
	taking_damage = false


# ─────────── DEATH ───────────

func die() -> void:

	if dying:
		return

	dying = true
	taking_damage = false

	boss_dead.emit()

	target = null
	player_in_range = null
	velocity = Vector2.ZERO

	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

	$DetectionArea.set_deferred("monitoring", false)
	$AttackArea.set_deferred("monitoring", false)

	animated_sprite.modulate = Color.WHITE
	animated_sprite.play("Death")

	print("♡ BOSS DEFEATED!")

	await animated_sprite.animation_finished

	if is_inside_tree():
		queue_free()


# ─────────── CLEANUP ───────────

func _exit_tree() -> void:

	player_in_range = null
	target = null


# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
#             END OF FILE
# ♡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━♡
