extends Control

var password = "a"
var correct_password: bool = false

signal main_menu

@onready var line_edit: LineEdit = $ColorRect/Panel/LineEdit

func ask_for_password():
	line_edit.text = ""
	show()
	

func check_password(input: String):
	if input == password:
		hide()
	else:
		main_menu.emit()


func change_password(current_password: String, new_password: String):
	if password == current_password:
		password = new_password
		
