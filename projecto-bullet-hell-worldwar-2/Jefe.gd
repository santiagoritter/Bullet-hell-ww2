extends CharacterBody2D

var vida = 500
var velocidad = 150.0
var distancia_deseada = 400.0

var limite_izq = -1500
var limite_der = 2650
var limite_arr = -320
var limite_abj = 890

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

	if direccion.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	if esta_atacando == false:
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
		if timer_ataque > 2.5:
			timer_ataque = 0.0
			lanzar_ataque()

	global_position.x = clamp(global_position.x, limite_izq, limite_der)
	global_position.y = clamp(global_position.y, limite_arr, limite_abj)

func lanzar_ataque():
	esta_atacando = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("Disparar")
	
	var tipo = randi() % 2
	
	if tipo == 0:
		await ataque_rafaga()
	else:
		ataque_abanico()
		await get_tree().create_timer(0.8).timeout 
	
	esta_atacando = false
	$AnimatedSprite2D.play("Quieto")

func ataque_rafaga():
	for i in range(6):
		if jugador != null:
			var angulo = (jugador.global_position - global_position).angle()
			crear_bala(angulo)
		await get_tree().create_timer(0.15).timeout

func ataque_abanico():
	if jugador != null:
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

func recibir_danio(cantidad):
	vida = vida - cantidad
	
	if vida <= 0:
		queue_free()
