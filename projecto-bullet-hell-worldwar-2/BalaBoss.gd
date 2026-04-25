extends Area2D

var velocidad = 250.0
var choco = false
var temporizador_borrar = 0.0

func _ready():
	scale = Vector2(0.1, 0.1)
	$AnimatedSprite2D.play("Normal")

func _physics_process(delta):
	if choco == false:
		var dir_x = cos(rotation)
		var dir_y = sin(rotation)
		position.x = position.x + (dir_x * velocidad * delta)
		position.y = position.y + (dir_y * velocidad * delta)
	else:
		temporizador_borrar = temporizador_borrar + delta
		if temporizador_borrar > 0.5:
			queue_free()

func _on_body_entered(body):
	if body.name == "Jugador_personaje" and choco == false:
		choco = true
		$CollisionShape2D.set_deferred("disabled", true)
		
		if body.has_method("recibir_danio"):
			body.recibir_danio(1)
		
		$AnimatedSprite2D.play("Crash")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
