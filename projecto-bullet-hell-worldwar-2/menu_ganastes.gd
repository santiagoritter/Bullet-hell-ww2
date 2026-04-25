extends Control

func _on_boton_jugar_pressed():
	get_tree().change_scene_to_file("res://raiz.tscn")

func _on_boton_menu_pressed():
	get_tree().change_scene_to_file("res://menu_principal.tscn")


func _on__pressed() -> void:
	pass
