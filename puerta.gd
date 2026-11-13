
extends StaticBody2D

# ♡ ───── DOOR STATUS ───── ♡

var player_nearby: bool = false
var is_open: bool = false
var is_opening: bool = false

var zona: Node2D = null
var unlocked: bool = false

var mensajes: CanvasLayer = null

# ♡ ───── NODES ───── ♡

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


# ♡ ───── INITIAL SETUP ───── ♡

func _ready() -> void:
	animated_sprite.play("closed")


# ♡ ───── DOOR INTERACTION ───── ♡

func _process(_delta: float) -> void:
	check_zombies()

	if player_nearby and Input.is_action_just_pressed("interactuar"):
		if not unlocked:
			if mensajes:
				mensajes.show_message(
					"NUH HUH! MATA A TODOS LOS ZOMBIES PRIMERO"
				)
			else:
				print("¡Todavía quedan zombies en esta zona!")
			return

		open_door()


# ♡ ───── ZOMBIE CHECK ───── ♡

func check_zombies() -> void:
	if unlocked or zona == null:
		return

	var zombies = zona.find_children(
		"*", "CharacterBody2D", true, false
	)

	for zombie in zombies:
		if zombie.is_in_group("zombies"):
			return

	unlocked = true
	print("♡ DOOR UNLOCKED: ", name)


# ♡ ───── OPEN ANIMATION ───── ♡

func open_door() -> void:
	if is_open or is_opening:
		return

	is_opening = true

	animated_sprite.play("open")
	await animated_sprite.animation_finished

	animated_sprite.play("opened")
	collision.set_deferred("disabled", true)

	is_open = true
	is_opening = false


# ♡ ───── PLAYER DETECTION ───── ♡

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
