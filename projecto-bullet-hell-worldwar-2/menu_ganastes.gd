extends Control

func _on_1_pressed() -> void:
	get_tree().change_scene_to_file("res://nivel_2.tscn")
	pass


func _on_2_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
	pass
