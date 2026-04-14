extends Area2D

var velocidad = 180.0
var dir = Vector2.ZERO

func _ready():
	var jugador = get_node("../../Jugador/Jugador_personaje")
	if jugador != null:
		dir = (jugador.global_position - global_position).normalized()
		rotation = dir.angle()

func _physics_process(delta):
	position += dir * velocidad * delta

func _on_body_entered(body):
	if body.name == "Jugador_personaje":
		if body.has_method("recibir_danio"):
			body.recibir_danio(1)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
