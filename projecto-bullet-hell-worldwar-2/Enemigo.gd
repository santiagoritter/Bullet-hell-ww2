extends CharacterBody2D

var velocidad = 250.0
var distancia_minima = 500.0 
var esta_muerto = false

var limite_izquierdo = -1500
var limite_derecho = 2650
var limite_arriba = -320
var limite_abajo = 890

var jugador = null

func _ready():
	jugador = get_node("../../Jugador/Jugador_personaje")

func _physics_process(delta):
	if esta_muerto:
		return

	if jugador != null:
		var distancia_total = global_position.distance_to(jugador.global_position)
		var anim_jugador = jugador.get_node("AnimatedSprite2D").animation
		
		if distancia_total < 80 and (anim_jugador == "Espada" or anim_jugador == "Ataque_especial1"):
			esta_muerto = true
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("MUERTO")
			return

		var distancia_x = abs(jugador.global_position.x - global_position.x)
		var direccion_x = (jugador.global_position.x - global_position.x)
		
		$AnimatedSprite2D.flip_h = direccion_x < 0

		if global_position.y < jugador.global_position.y - 10:
			velocity.y = velocidad
		elif global_position.y > jugador.global_position.y + 10:
			velocity.y = -velocidad
		else:
			velocity.y = 0

		if distancia_x > distancia_minima:
			velocity.x = (1 if direccion_x > 0 else -1) * velocidad
			$AnimatedSprite2D.play("Caminar")
		else:
			velocity.x = 0
			$AnimatedSprite2D.play("Disparar")

		move_and_slide()

	global_position.x = clamp(global_position.x, limite_izquierdo, limite_derecho)
	global_position.y = clamp(global_position.y, limite_arriba, limite_abajo)
