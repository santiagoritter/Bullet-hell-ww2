extends CharacterBody2D

var velocidad = 400.0

func _Atacar():
	if Input.is_physical_key_pressed(KEY_SPACE):
		$AnimatedSprite2D.play("Espada")


func _physics_process(delta):
	var direccion_Y = 0
	var direccion_X = 0
	
	if Input.is_physical_key_pressed(KEY_W):
		direccion_Y -= 1
	if Input.is_physical_key_pressed(KEY_S):
		direccion_Y += 1
	if Input.is_physical_key_pressed(KEY_A):
		direccion_X -= 1
	if Input.is_physical_key_pressed(KEY_D):
		direccion_X += 1
	if Input.is_physical_key_pressed(KEY_SPACE):
		$AnimatedSprite2D.play("Espada")
	
	if direccion_X == 0:
		$AnimatedSprite2D.play("Quieto")
		
	velocity.y = direccion_Y * velocidad
	velocity.x = direccion_X * velocidad
	move_and_slide()
