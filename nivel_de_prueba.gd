
extends Node2D

# ♡ ───── LEVEL SETUP ───── ♡

func _ready() -> void:
	var map = $Map
	var messages = $Mensajes

	# ♡ Door connections

	map.get_node("Puerta").zona = $Zona1
	map.get_node("Puerta2").zona = $Zona3
	map.get_node("Puerta3").zona = $Zona4
	map.get_node("Puerta6").zona = $Zona6

	map.get_node("Puerta7").zona = $Zona6
	map.get_node("Puerta8").zona = $Zona6
	map.get_node("Puerta9").zona = $Zona6
	map.get_node("Puerta10").zona = $Zona6
	map.get_node("Puerta11").zona = $Zona6
	map.get_node("Puerta12").zona = $Zona6
	map.get_node("Puerta13").zona = $Zona7

	# ♡ Assign messages to every door

	for door in map.find_children("*", "StaticBody2D", true, false):
		if door.has_method("open_door"):
			door.mensajes = messages

	print("♡ LEVEL DOORS CONFIGURED")
