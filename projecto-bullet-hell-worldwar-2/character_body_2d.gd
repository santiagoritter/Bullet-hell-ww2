extends CharacterBody2D

var vida = 3
var velocidad = 400.0
var esta_atacando = false
var escudo = false
var tiempo_e = 0.0
var tiempo_invencible = 0.0
var codigo_konami = [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT, KEY_B, KEY_A]
var paso_codigo = 0
var vida_infinita = false
var lim_izq = -1500
var lim_der = 2650
var lim_arr = -320
var lim_abj = 890

func _ready():
	if has_node("CanvasLayer/ProgressBar"):
		$CanvasLayer/ProgressBar.max_value = vida
		$CanvasLayer/ProgressBar.value = vida

func _input(event):
	if event is InputEventKey and event.pressed and event.echo == false:
		if event.keycode == codigo_konami[paso_codigo]:
			paso_codigo = paso_codigo + 1
			if paso_codigo == 10:
				vida_infinita = true
				paso_codigo = 0
		else:
			paso_codigo = 0
			if event.keycode == KEY_UP:
				paso_codigo = 1

func _physics_process(delta):
	if tiempo_e > 0:
		tiempo_e = tiempo_e - delta
	if tiempo_invencible > 0:
		tiempo_invencible = tiempo_invencible - delta
	var vy = 0
	var vx = 0
	
	if Input.is_physical_key_pressed(KEY_W):
		vy = vy - 1
	if Input.is_physical_key_pressed(KEY_S):
		vy = vy + 1
	if Input.is_physical_key_pressed(KEY_A):
		if esta_atacando == false:
			$AnimatedSprite2D.flip_h = true
		vx = vx - 1
	if Input.is_physical_key_pressed(KEY_D):
		if esta_atacando == false:
			$AnimatedSprite2D.flip_h = false
		vx = vx + 1
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
		if vy == 0 and vx == 0:
			$AnimatedSprite2D.play("Quieto")
		else:
			$AnimatedSprite2D.play("Caminar")
	velocity.y = vy * velocidad
	velocity.x = vx * velocidad
	move_and_slide()
	global_position.x = clamp(global_position.x, lim_izq, lim_der)
	global_position.y = clamp(global_position.y, lim_arr, lim_abj)

func recibir_danio(cantidad):
	if escudo == true or tiempo_invencible > 0 or vida_infinita == true:
		return
	vida = vida - cantidad
	if has_node("CanvasLayer/ProgressBar"):
		$CanvasLayer/ProgressBar.value = vida
	if vida <= 0:
		get_tree().change_scene_to_file("res://menu_perdistes.tscn")
