extends Control


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Title.tscn")


func _on_Test_pressed():
	get_tree().change_scene("res://Scenes/TestGround.tscn")