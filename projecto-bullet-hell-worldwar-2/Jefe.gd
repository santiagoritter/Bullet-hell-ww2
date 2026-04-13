extends CharacterBody2D

var velocidad = 150.0
var distancia_deseada = 400.0

var limite_izquierdo = -1500
var limite_derecho = 2650
var limite_arriba = -320
var limite_abajo = 890

var timer_ataque = 0.0
var esta_atacando = false
var bala_escena = preload("res://BalaBoss.tscn")
var jugador = null

func _ready():
	jugador = get_node("../../Jugador/Jugador_personaje")

func _physics_process(delta):
	if jugador == null:
		return

	var distancia = global_position.distance_to(jugador.global_position)
	var direccion = (jugador.global_position - global_position).normalized()

	$AnimatedSprite2D.flip_h = direccion.x < 0

	if not esta_atacando:
		if distancia > distancia_deseada + 50:
			velocity = direccion * velocidad
			$AnimatedSprite2D.play("Caminar")
		elif distancia < distancia_deseada - 50:
			velocity = -direccion * velocidad
			$AnimatedSprite2D.play("Caminar")
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("Quieto")
		
		move_and_slide()

	timer_ataque += delta
	if timer_ataque > 2.5 and not esta_atacando:
		esta_atacando = true
		lanzar_ataque()
		timer_ataque = 0.0

	global_position.x = clamp(global_position.x, limite_izquierdo, limite_derecho)
	global_position.y = clamp(global_position.y, limite_arriba, limite_abajo)

func lanzar_ataque():
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("Disparar")
	
	var tipo_ataque = randi() % 3
	
	if tipo_ataque == 0:
		ataque_circulo()
	elif tipo_ataque == 1:
		await ataque_rafaga()
	else:
		ataque_abanico()
	
	await $AnimatedSprite2D.animation_finished
	esta_atacando = false

func ataque_circulo():
	var num_balas = 16
	for i in range(num_balas):
		var angulo = i * (PI * 2 / num_balas)
		crear_bala(angulo)

func ataque_rafaga():
	for i in range(6):
		if jugador:
			var angulo_jugador = (jugador.global_position - global_position).angle()
			crear_bala(angulo_jugador)
		await get_tree().create_timer(0.15).timeout

func ataque_abanico():
	if jugador:
		var angulo_base = (jugador.global_position - global_position).angle()
		crear_bala(angulo_base)
		crear_bala(angulo_base + 0.25)
		crear_bala(angulo_base - 0.25)
		crear_bala(angulo_base + 0.5)
		crear_bala(angulo_base - 0.5)

func crear_bala(angulo):
	var nueva_bala = bala_escena.instantiate()
	get_parent().add_child(nueva_bala)
	nueva_bala.global_position = global_position
	nueva_bala.rotation = angulo
