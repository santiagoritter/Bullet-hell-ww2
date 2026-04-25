extends CharacterBody2D

var vida = 3
var velocidad = 400.0
var esta_atacando = false
var escudo = false
var tiempo_e = 0.0
var tiempo_invencible = 0.0

var limite_izquierdo = -1500
var limite_derecho = 2650
var limite_arriba = -320
var limite_abajo = 890

func _ready():
	$CanvasLayer/ProgressBar.max_value = vida
	$CanvasLayer/ProgressBar.value = vida

func _physics_process(delta):
	if tiempo_e > 0:
		tiempo_e = tiempo_e - delta
		$CanvasLayer/LabelE.text = str(int(tiempo_e) + 1)
	else:
		$CanvasLayer/LabelE.text = "Press (E)"

	if tiempo_invencible > 0:
		tiempo_invencible = tiempo_invencible - delta

	var direccion_Y = 0
	var direccion_X = 0
	
	if Input.is_physical_key_pressed(KEY_W):
		direccion_Y = direccion_Y - 1
	if Input.is_physical_key_pressed(KEY_S):
		direccion_Y = direccion_Y + 1
	if Input.is_physical_key_pressed(KEY_A):
		if esta_atacando == false:
			$AnimatedSprite2D.flip_h = true
		direccion_X = direccion_X - 1
	if Input.is_physical_key_pressed(KEY_D):
		if esta_atacando == false:
			$AnimatedSprite2D.flip_h = false
		direccion_X = direccion_X + 1
	
	if Input.is_physical_key_pressed(KEY_SPACE) and esta_atacando == false:
		esta_atacando = true
		$AnimatedSprite2D.play("Espada")
		await $AnimatedSprite2D.animation_finished
		esta_atacando = false
		
	elif Input.is_physical_key_pressed(KEY_E) and esta_atacando == false and tiempo_e <= 0:
		esta_atacando = true
		escudo = true
		tiempo_e = 5.0
		$AnimatedSprite2D.play("Ataque_especial1")
		await $AnimatedSprite2D.animation_finished
		escudo = false
		esta_atacando = false
		
	if esta_atacando == false:
		if direccion_Y == 0 and direccion_X == 0:
			$AnimatedSprite2D.play("Quieto")
		else:
			$AnimatedSprite2D.play("Caminar")
		
	velocity.y = direccion_Y * velocidad
	velocity.x = direccion_X * velocidad
	move_and_slide()

	global_position.x = clamp(global_position.x, limite_izquierdo, limite_derecho)
	global_position.y = clamp(global_position.y, limite_arriba, limite_abajo)

func recibir_danio(cantidad):
	if escudo == true or tiempo_invencible > 0:
		return

	vida = vida - cantidad
	$CanvasLayer/ProgressBar.value = vida
	
	if vida <= 0:
		get_tree().change_scene_to_file("res://menu_perdistes.tscn")
