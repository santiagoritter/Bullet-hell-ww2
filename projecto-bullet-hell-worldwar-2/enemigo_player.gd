extends CharacterBody2D

var velocidad = 400.0
var esta_atacando = false

var limite_izquierdo = -1500
var limite_derecho = 2650
var limite_arriba = -320
var limite_abajo = 890

func _physics_process(delta):
	var direccion_Y = 0
	var direccion_X = 0
	
	if Input.is_physical_key_pressed(KEY_UP) and not esta_atacando:
		direccion_Y -= 1
	if Input.is_physical_key_pressed(KEY_DOWN) and not esta_atacando:
		direccion_Y += 1
	if Input.is_physical_key_pressed(KEY_LEFT) and not esta_atacando:
		$AnimatedSprite2D.flip_h = true
		direccion_X -= 1
	if Input.is_physical_key_pressed(KEY_RIGHTd) and not esta_atacando:
		$AnimatedSprite2D.flip_h = false
		direccion_X += 1
	
	if Input.is_physical_key_pressed(KEY_SPACE) and not esta_atacando:
		esta_atacando = true
		$AnimatedSprite2D.play("Espada")
		await $AnimatedSprite2D.animation_finished
		esta_atacando = false
		
	elif Input.is_physical_key_pressed(KEY_E) and not esta_atacando:
		esta_atacando = true
		$AnimatedSprite2D.play("Ataque_especial1")
		await $AnimatedSprite2D.animation_finished
		esta_atacando = false
		
	if not esta_atacando:
		if direccion_Y == 0 and direccion_X == 0:
			$AnimatedSprite2D.play("Quieto")
		else:
			$AnimatedSprite2D.play("Caminar")
		
	velocity.y = direccion_Y * velocidad
	velocity.x = direccion_X * velocidad
	move_and_slide()

	global_position.x = clamp(global_position.x, limite_izquierdo, limite_derecho)
	global_position.y = clamp(global_position.y, limite_arriba, limite_abajo)
