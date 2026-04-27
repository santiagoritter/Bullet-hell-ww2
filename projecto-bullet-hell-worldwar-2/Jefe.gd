extends CharacterBody2D

var vida = 500
var velocidad = 150.0
var dist_objetivo = 400.0
var timer_pum = 0.0
var timer_invencible = 0.0
var esta_atacando = false
var bala_escena = preload("res://BalaBoss.tscn")
var jugador = null
var limite_izquierdo = -1500
var limite_derecho = 2650
var limite_arriba = -320
var limite_abajo = 890

func _ready():
	add_to_group("grupo_jefes")
	jugador = get_tree().get_root().find_child("Jugador_personaje", true, false)
	if has_node("BarraVidaJefe"):
		$BarraVidaJefe.max_value = vida
		$BarraVidaJefe.value = vida

func _physics_process(delta):
	if jugador == null: return
	var dist = global_position.distance_to(jugador.global_position)
	var dir = (jugador.global_position - global_position).normalized()
	if timer_invencible > 0:
		timer_invencible = timer_invencible - delta
	var anim_jug = jugador.get_node("AnimatedSprite2D").animation
	if dist < 120 and timer_invencible <= 0:
		if anim_jug == "Espada" or anim_jug == "Ataque_especial1":
			recibir_danio(50)
			timer_invencible = 1.2
	if esta_atacando == false:
		if dist > dist_objetivo + 20:
			velocity = dir * velocidad
			$AnimatedSprite2D.play("Caminar")
		elif dist < dist_objetivo - 20:
			velocity = dir * -velocidad
			$AnimatedSprite2D.play("Caminar")
		else:
			velocity = Vector2(0, 0)
			$AnimatedSprite2D.play("Quieto")
		move_and_slide()
		timer_pum = timer_pum + delta
		if timer_pum > 2.5:
			timer_pum = 0.0
			hacer_combo()
	global_position.x = clamp(global_position.x, limite_izquierdo, limite_derecho)
	global_position.y = clamp(global_position.y, limite_arriba, limite_abajo)
	if (jugador.global_position.x - global_position.x) < 0: 
		$AnimatedSprite2D.flip_h = true
	else: 
		$AnimatedSprite2D.flip_h = false

func hacer_combo():
	esta_atacando = true
	$AnimatedSprite2D.play("Disparar")
	var random = randi() % 2
	if random == 0:
		for i in range(6):
			crear_bala((jugador.global_position - global_position).angle())
			await get_tree().create_timer(0.15).timeout
	else:
		var ang = (jugador.global_position - global_position).angle()
		crear_bala(ang); crear_bala(ang+0.3); crear_bala(ang-0.3)
		await get_tree().create_timer(0.8).timeout
	esta_atacando = false

func crear_bala(angulo):
	var b = bala_escena.instantiate()
	get_parent().add_child(b)
	b.global_position = global_position
	b.rotation = angulo

func recibir_danio(puntos):
	vida = vida - puntos
	if has_node("BarraVidaJefe"):
		$BarraVidaJefe.value = vida
	if vida <= 0:
		remove_from_group("grupo_jefes")
		var restantes = get_tree().get_nodes_in_group("grupo_jefes").size()
		if restantes == 0:
			get_tree().change_scene_to_file("res://menu_ganastes.tscn")
		else:
			queue_free()
