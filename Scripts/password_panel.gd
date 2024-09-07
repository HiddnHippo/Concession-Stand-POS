extends Control

var password = "GoRocks"
var correct_password: bool = false

signal main_menu

@onready var line_edit: LineEdit = $ColorRect/Panel/LineEdit

func ask_for_password():
	line_edit.clear()
	line_edit.grab_focus()
	show()
	

func check_password(input: String):
	if input == password:
		hide()
	else:
		main_menu.emit()
