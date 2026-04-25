extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://raiz.tscn")

func _on_button_2_pressed():
	print("El Nivel 2 todavía no existe")
