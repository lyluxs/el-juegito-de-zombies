extends TextureRect
@onready var numero: Label = get_node_or_null("NumeroZombies")
var zombies_restantes: int = 0
#olasoychad
func _ready():
	await get_tree().process_frame

	if numero == null:
		push_error("Ta mal w")
		return

	var zombies = get_tree().get_nodes_in_group("zombies")
	zombies_restantes = zombies.size()

	for zombie in zombies:
		if zombie.has_signal("zombie_muerto"):
			var callback = Callable(self, "_on_zombie_muerto")

			if not zombie.is_connected("zombie_muerto", callback):
				zombie.connect("zombie_muerto", callback)

	actualizar_contador()

func _on_zombie_muerto():
	zombies_restantes = max(zombies_restantes - 1, 0)
	actualizar_contador()

func actualizar_contador():
	if numero != null:
		numero.text = str(zombies_restantes)
