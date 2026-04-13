extends Area2D

var velocidad_bala = 300

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * velocidad_bala * delta

func _on_body_entered(body):
	if body.name == "Jugador_personaje":
		if body.has_method("recibir_danio"):
			body.recibir_danio(1)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
