
extends Node2D


func _ready():
	var mapa = $Map

	mapa.get_node("Puerta").zona = $Zona1
	mapa.get_node("Puerta2").zona = $Zona3
	mapa.get_node("Puerta3").zona = $Zona4
	mapa.get_node("Puerta6").zona = $Zona6

	mapa.get_node("Puerta7").zona = $Zona6
	mapa.get_node("Puerta8").zona = $Zona6
	mapa.get_node("Puerta9").zona = $Zona6
	mapa.get_node("Puerta10").zona = $Zona6
	mapa.get_node("Puerta11").zona = $Zona6
	mapa.get_node("Puerta12").zona = $Zona6
	mapa.get_node("Puerta13").zona = $Zona7
	var mensajes = $Mensajes

	for puerta in $Map.find_children("*", "StaticBody2D", true, false):
		if puerta.has_method("abrir_puerta"):
			puerta.mensajes = mensajes
