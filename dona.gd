
extends StaticBody2D

var player_nearby: bool = false
var collected: bool = false

@export var health_amount: int = 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var area_collision: CollisionShape2D = $Area2D/CollisionShape2D


func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interactuar"):
		collect_donut()


func collect_donut() -> void:
	if collected:
		return

	var player = get_node_or_null("../Player")

	if player == null:
		print("Player not found")
		return

	print("Health before donut: ", player.current_health)

	var restored: bool = player.restore_health(health_amount)

	if not restored:
		print("Health is already full!")
		return

	collected = true

	print("Health after donut: ", player.current_health)

	sprite.hide()
	collision.set_deferred("disabled", true)
	area_collision.set_deferred("disabled", true)

	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_nearby = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_nearby = false
