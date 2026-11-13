
extends Camera2D

# ♡ ───── CAMERA SETTINGS ───── ♡

@export var player: Node2D


# ♡ ───── FOLLOW PLAYER ───── ♡

func _process(_delta: float) -> void:
	if player:
		global_position = player.global_position
