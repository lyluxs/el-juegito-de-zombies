
extends CanvasLayer

# ♡ ───── PLAYER SETTINGS ───── ♡

@export var player: Node2D

# ♡ ───── HEART TEXTURES ───── ♡

@export_group("Heart Textures")
@export var full_heart: Texture2D
@export var half_heart: Texture2D
@export var empty_heart: Texture2D

# ♡ ───── HEART NODES ───── ♡

@onready var hearts: Array[TextureRect] = [
	$HBoxContainer/Heart1,
	$HBoxContainer/Heart2,
	$HBoxContainer/Heart3
]


# ♡ ───── INITIAL SETUP ───── ♡

func _ready() -> void:
	if player:
		player.health_changed.connect(update_health)
		update_health(player.current_health)
	else:
		push_warning("Player no esta asignado w")


# ♡ ───── UPDATE HEALTH BAR ───── ♡

func update_health(health: int) -> void:
	for i in range(hearts.size()):
		var heart_health = health - (i * 2)

		if heart_health >= 2:
			hearts[i].texture = full_heart
		elif heart_health == 1:
			hearts[i].texture = half_heart
		else:
			hearts[i].texture = empty_heart
