extends Area2D

var velocidad = 250.0
var chocó = false

func _ready():
	$AnimatedSprite2D.play("Normal")
	$AnimatedSprite2D.scale = Vector2(0.1, 0.1)
func _physics_process(delta):
	if chocó == false:
		position += Vector2.RIGHT.rotated(rotation) * velocidad * delta

func _on_body_entered(body):
	if body.name == "Jugador_personaje" and chocó == false:
		chocó = true
		if body.has_method("recibir_danio"):
			body.recibir_danio(1)
		
		$AnimatedSprite2D.play("Crash")
		await $AnimatedSprite2D.animation_finished
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
