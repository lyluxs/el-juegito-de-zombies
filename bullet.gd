
extends Area2D

@export var speed: float = 100.0
@export var damage: int = 1

var direction: Vector2 = Vector2.RIGHT

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	direction = direction.normalized()
	rotation = direction.angle()


func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.name == "SillyZombie" or body.name == "Zombie":
		if body.has_method("recibir_golpe"):
			body.recibir_golpe()
		queue_free()

	elif body is TileMapLayer or body is StaticBody2D:
		queue_free()
