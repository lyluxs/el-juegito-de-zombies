
extends Node2D


# ♡ Menu configuration

@export_group("Play")
@export var play_normal: Texture2D
@export var play_active: Texture2D

@export_group("Exit")
@export var exit_normal: Texture2D
@export var exit_active: Texture2D

@export_group("Scenes")
@export_file("*.tscn") var level_scene = "res://nivel_de_prueba.tscn"


# ✧ Menu nodes

@onready var background = $Camera2D/Background
@onready var logo = $MenuVertical/Logo
@onready var play_button = $MenuVertical/Play
@onready var exit_button = $MenuVertical/Exit

var buttons = []
var selected_option = 0

var selection_tween: Tween
var logo_tween: Tween


# ♡ Initialize menu

func _ready():

	buttons = [play_button, exit_button]

	# Center button pivots
	for button in buttons:
		button.pivot_offset_ratio = Vector2(0.5, 0.5)
		button.scale = Vector2(0.8, 0.8)
		button.modulate.a = 0.0

	# Start animations
	update_selection()
	animate_buttons()
	animate_logo()
	animate_background()


# ✧ Button entrance animation

func animate_buttons():

	var intro = create_tween()
	intro.set_parallel(true)

	for button in buttons:
		intro.tween_property(
			button, "scale", Vector2.ONE, 0.5
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		intro.tween_property(
			button, "modulate:a", 1.0, 0.5
		)


# ♡ Logo animation

func animate_logo():

	logo.modulate.a = 0.0
	logo.scale = Vector2(0.8, 0.8)

	var intro = create_tween()
	intro.set_parallel(true)

	intro.tween_property(
		logo, "modulate:a", 1.0, 0.8
	)

	intro.tween_property(
		logo, "scale", Vector2.ONE, 0.8
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	await intro.finished

	# Floating effect
	var original_position = logo.position

	logo_tween = create_tween()
	logo_tween.set_loops()

	logo_tween.tween_property(
		logo, "position:y", original_position.y - 2.0, 1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	logo_tween.tween_property(
		logo, "position:y", original_position.y + 2.0, 1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


# ✧ Background zoom and appearance

func animate_background():

	background.scale = Vector2(1.08, 1.08)
	background.modulate.a = 0.0

	var intro = create_tween()
	intro.set_parallel(true)

	intro.tween_property(
		background, "scale", Vector2.ONE, 1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	intro.tween_property(
		background, "modulate:a", 1.0, 1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


# ✧ Handle menu input

func _process(_delta):

	if Input.is_action_just_pressed("ui_down"):
		selected_option = (selected_option + 1) % buttons.size()
		update_selection()

	elif Input.is_action_just_pressed("ui_up"):
		selected_option = (selected_option - 1 + buttons.size()) % buttons.size()
		update_selection()

	elif Input.is_action_just_pressed("ui_accept"):
		select_option()


# ♡ Update selection

func update_selection():

	# Update button textures
	play_button.get_node("background").texture = (
		play_active if selected_option == 0 else play_normal
	)

	exit_button.get_node("background").texture = (
		exit_active if selected_option == 1 else exit_normal
	)

	# Stop previous animation
	if selection_tween and selection_tween.is_running():
		selection_tween.kill()

	selection_tween = create_tween()
	selection_tween.set_parallel(true)

	# Centered scale animation
	for i in range(buttons.size()):

		var button = buttons[i]
		var target = Vector2.ONE

		if i == selected_option:
			target = Vector2(1.08, 1.08)

		selection_tween.tween_property(
			button,
			"scale",
			target,
			0.2
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


# ✧ Execute selected option

func select_option():

	match selected_option:

		0:
			get_tree().change_scene_to_file(level_scene)

		1:
			get_tree().quit()


# ♡ End of menu
