extends CharacterBody2D

@export var speed := 80.0

var Player: CharacterBody2D

func _ready():
	Player = get_tree().get_first_node_in_group("Player")
