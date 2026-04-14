extends CharacterBody2D

var vida = 500
var velocidad = 150.0
var dist_objetivo = 400.0

var lim_izq = -1500
var lim_der = 2650
var lim_arr = -320
var lim_abj = 890

var timer_pum = 0.0
var timer_invencible = 0.0
var esta_atacando = false
var bala_escena = preload("res://BalaBoss.tscn")
var jugador = null

func _ready():
	jugador = get_node("../../Jugador/Jugador_personaje")
	$CanvasLayer/BarraVidaJefe.max_value = vida
	$CanvasLayer/BarraVidaJefe.value = vida

func _physics_process(delta):
	if jugador == null:
		return

	var dist = global_position.distance_to(jugador.global_position)
	var dir = (jugador.global_position - global_position).normalized()

	if dir.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	if timer_invencible > 0:
		timer_invencible -= delta

	var anim_jugador = jugador.get_node("AnimatedSprite2D").animation
	if dist < 120 and timer_invencible <= 0:
		if anim_jugador == "Espada" or anim_jugador == "Ataque_especial1":
			recibir_danio(50)
			timer_invencible = 1.2

	if esta_atacando == false:
		if dist > dist_objetivo + 50:
			velocity = dir * velocidad
			$AnimatedSprite2D.play("Caminar")
		elif dist < dist_objetivo - 50:
			velocity = -dir * velocidad
			$AnimatedSprite2D.play("Caminar")
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("Quieto")
		
		move_and_slide()

		timer_pum += delta
		if timer_pum > 2.5:
			timer_pum = 0.0
			hacer_combo()

	global_position.x = clamp(global_position.x, lim_izq, lim_der)
	global_position.y = clamp(global_position.y, lim_arr, lim_abj)

func hacer_combo():
	esta_atacando = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("Disparar")
	
	var random = randi() % 2
	
	if random == 0:
		await ataque_rafaga()
	else:
		ataque_abanico()
		await get_tree().create_timer(0.8).timeout 
	
	esta_atacando = false
	$AnimatedSprite2D.play("Quieto")

func ataque_rafaga():
	for i in range(6):
		if jugador != null:
			var ang = (jugador.global_position - global_position).angle()
			crear_bala(ang)
		await get_tree().create_timer(0.15).timeout

func ataque_abanico():
	if jugador != null:
		var ang_base = (jugador.global_position - global_position).angle()
		crear_bala(ang_base)
		crear_bala(ang_base + 0.25)
		crear_bala(ang_base - 0.25)
		crear_bala(ang_base + 0.5)
		crear_bala(ang_base - 0.5)

func crear_bala(angulo):
	var b = bala_escena.instantiate()
	get_parent().add_child(b)
	b.global_position = global_position
	b.rotation = angulo

func recibir_danio(puntos):
	vida = vida - puntos
	$CanvasLayer/BarraVidaJefe.value = vida
	
	if vida <= 0:
		queue_free()
		get_tree().reload_current_scene()
