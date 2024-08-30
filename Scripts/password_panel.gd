extends Control

var password = "asdf1234"

signal password_passed
signal main_menu

@onready var line_edit: LineEdit = $ColorRect/Panel/LineEdit

func check_password(input_text):
	if input_text == password:
		password_passed.emit()
	else:
		hide()
		main_menu.emit()
