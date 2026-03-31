extends CharacterBody2D

var velocidad = 400.0
var esta_atacando = false

func _physics_process(delta):
	var direccion_Y = 0
	var direccion_X = 0
	
	if Input.is_physical_key_pressed(KEY_W):
		direccion_Y -= 1
		
	if Input.is_physical_key_pressed(KEY_S):
		direccion_Y += 1
	if Input.is_physical_key_pressed(KEY_A):
		$AnimatedSprite2D.flip_h = true
		direccion_X -= 1
	if Input.is_physical_key_pressed(KEY_D):
		$AnimatedSprite2D.flip_h = false
		direccion_X += 1
	
	if Input.is_physical_key_pressed(KEY_SPACE) and not esta_atacando:
		esta_atacando = true
		$AnimatedSprite2D.play("Espada")
		await $AnimatedSprite2D.animation_finished
		esta_atacando = false
		velocidad = 300
		
	if Input.is_physical_key_pressed(KEY_E) and not esta_atacando:
		esta_atacando = true
		velocidad = 200
		$AnimatedSprite2D.play("Ataque_especial1")
		await $AnimatedSprite2D.animation_finished
		esta_atacando = false
		
	if not esta_atacando:
		if direccion_Y == 0 and direccion_X == 0:
			$AnimatedSprite2D.play("Quieto")
		else:
			$AnimatedSprite2D.play("Caminar")
			velocidad = 400
		
	velocity.y = direccion_Y * velocidad
	velocity.x = direccion_X * velocidad
	move_and_slide()
