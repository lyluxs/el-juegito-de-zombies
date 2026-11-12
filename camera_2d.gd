extends Camera2D

@export var jugador: Node2D

func _process(_delta):
	if jugador:
		global_position = jugador.global_position
