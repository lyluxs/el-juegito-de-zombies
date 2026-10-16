extends CharacterBody2D

@export var velocidad: float = 30.0
@export var vida: int = 3

var objetivo: Node2D = null

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(_delta):
	if objetivo:
		var direccion = global_position.direction_to(objetivo.global_position)
		velocity = direccion * velocidad
		move_and_slide()
		animated_sprite.play("Walk")
	else:
		velocity = Vector2.ZERO
		animated_sprite.stop()


func _on_detection_area_body_entered(body):
	if body.name == "Player":
		objetivo = body
		print("PLAYER DETECTADO")


		

func _on_detection_area_body_exited(body):
	if body == objetivo:
		objetivo = null
		print("PLAYER SALIÓ DEL ÁREA")
func recibir_golpe(): 
	vida -= 1
	print("Vida del zombie: ", vida)

	animated_sprite.modulate = Color(1, 0, 0) 
	await get_tree().create_timer(0.2).timeout 
	if not is_inside_tree(): 
		return 
	animated_sprite.modulate = Color(1, 1, 1)
	
	if vida <= 0:
		queue_free()
