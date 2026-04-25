extends CharacterBody2D

var velocidad = 200.0
var dist_freno = 400.0
var esta_muerto = false

var lim_izq = -1500
var lim_der = 2650
var lim_arr = -320
var lim_abj = 890

var timer_tiro = 0.0
var jugador = null
var bala_enemigo = preload("res://bala_enemigo.tscn")

func _ready():
	jugador = get_node("../../Jugador/Jugador_personaje")

func _physics_process(delta):
	if esta_muerto or jugador == null:
		return

	var dist = global_position.distance_to(jugador.global_position)
	var dir = (jugador.global_position - global_position).normalized()
	
	if dir.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	var anim_jugador = jugador.get_node("AnimatedSprite2D").animation
	if dist < 120:
		if anim_jugador == "Espada" or anim_jugador == "Ataque_especial1":
			esta_muerto = true
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("MUERTO")
			await $AnimatedSprite2D.animation_finished
			queue_free()
			return

	if dist > dist_freno:
		velocity = dir * velocidad
		$AnimatedSprite2D.play("Caminar")
	else:
		velocity = Vector2.ZERO
		if timer_tiro < 1.5:
			$AnimatedSprite2D.play("Quieto")
		else:
			$AnimatedSprite2D.play("Disparar")

	move_and_slide()

	timer_tiro += delta
	if timer_tiro > 2.0:
		disparar_recto()
		timer_tiro = 0.0

	global_position.x = clamp(global_position.x, lim_izq, lim_der)
	global_position.y = clamp(global_position.y, lim_arr, lim_abj)

func disparar_recto():
	var nueva_b = bala_enemigo.instantiate()
	nueva_b.global_position = global_position
	get_parent().add_child(nueva_b)
