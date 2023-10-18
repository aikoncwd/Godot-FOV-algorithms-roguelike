extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Raycasting.tscn")

func _on_Button2_pressed():
	get_tree().change_scene("res://scenes/Shadowcasting.tscn")


func _on_Label4_gui_input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		OS.shell_open("https://aikoncwd.itch.io")
